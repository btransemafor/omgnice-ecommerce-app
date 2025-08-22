

// chatbot.services.js
const { GoogleGenerativeAI } = require("@google/generative-ai");
const { pineconeIndex } = require("../utils/pineconeUtils");
require("dotenv").config();

// Khởi tạo AI client
const genAI = new GoogleGenerativeAI(
  process.env.GEMINI_API_KEY
);
const model = genAI.getGenerativeModel({ model: "gemini-2.0-flash" });

// Constants
const SHOP_CONFIG = {
  name: "OMGNICE",
  owner: "TranVo",
  description: "nơi có người chủ siêu cấp cute",
  maxResults: 3,
  namespace: "products"
};

const RESPONSE_TYPES = {
  GREETING: "greeting",
  PRODUCT: "product",
  POLICY: "policy",
  ERROR: "error"
};

const LANGUAGES = {
  VI: "vi",
  EN: "en"
};

const LANGUAGE_CONFIG = {
  vi: {
    name: "Tiếng Việt",
    greeting_patterns: [
      /^(xin chào|chào|chào bạn|xin chào bạn|hi|hello|hey)/i
    ],
    fallback_messages: {
      general: "Xin lỗi, tôi không thể trả lời lúc này.",
      no_product: "Tôi không tìm thấy thông tin về sản phẩm này. Bạn có thể mô tả chi tiết hơn không?",
      no_policy: "Xin lỗi, tôi chưa có đủ thông tin để trả lời câu hỏi này. Vui lòng liên hệ bộ phận CSKH để được hỗ trợ.",
      search_error: "Đã xảy ra lỗi khi tìm kiếm sản phẩm. Vui lòng thử lại sau.",
      no_search_results: "Không tìm thấy sản phẩm nào phù hợp với \"{query}\". Bạn có thể thử từ khóa khác hoặc liên hệ trực tiếp với chúng tôi.",
      empty_query: "Vui lòng nhập từ khóa tìm kiếm.",
      empty_question: "Vui lòng nhập câu hỏi của bạn.",
      need_more_info: "Tôi cần thêm thông tin để có thể trả lời câu hỏi của bạn.",
      general_error: "Xin lỗi, đã xảy ra lỗi. Vui lòng thử lại sau."
    }
  },
  en: {
    name: "English",
    greeting_patterns: [
      /^(hi|hello|hey|good morning|good afternoon|good evening)/i
    ],
    fallback_messages: {
      general: "Sorry, I can't answer right now.",
      no_product: "I couldn't find information about this product. Could you provide more details?",
      no_policy: "Sorry, I don't have enough information to answer this question. Please contact our customer service for support.",
      search_error: "An error occurred while searching for products. Please try again later.",
      no_search_results: "No products found matching \"{query}\". You can try different keywords or contact us directly.",
      empty_query: "Please enter a search keyword.",
      empty_question: "Please enter your question.",
      need_more_info: "I need more information to answer your question.",
      general_error: "Sorry, an error occurred. Please try again later."
    }
  }
};

// Utility functions
const detectLanguage = (text) => {
  const cleanText = text.trim().toLowerCase();
  
  // Vietnamese patterns
  const viPatterns = [
    /[àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểỄòóọỏõôồốộổỗơờớợởỡìíịỉĩùúụủũưừứựửữỳýỵỷỹđ]/,
    /\b(xin chào|chào|cảm ơn|cám ơn|sản phẩm|giá|mua|bán|shop|cửa hàng)\b/
  ];
  
  // English patterns  
  const enPatterns = [
    /\b(hello|hi|thank you|thanks|product|price|buy|sell|shop|store)\b/,
    /^[a-zA-Z\s.,!?]+$/ // Only English characters
  ];
  
  const hasVietnamese = viPatterns.some(pattern => pattern.test(cleanText));
  const hasEnglish = enPatterns.some(pattern => pattern.test(cleanText));
  
  // If both or neither detected, default to Vietnamese
  if (hasVietnamese || (!hasVietnamese && !hasEnglish)) {
    return LANGUAGES.VI;
  }
  
  return LANGUAGES.EN;
};

const isGreeting = (text, language = LANGUAGES.VI) => {
  const patterns = LANGUAGE_CONFIG[language]?.greeting_patterns || LANGUAGE_CONFIG.vi.greeting_patterns;
  return patterns.some(pattern => pattern.test(text.trim()));
};

const sanitizeInput = (input) => {
  return input ? input.trim().replace(/[<>]/g, '') : '';
};

const getMessage = (key, language = LANGUAGES.VI, replacements = {}) => {
  const messages = LANGUAGE_CONFIG[language]?.fallback_messages || LANGUAGE_CONFIG.vi.fallback_messages;
  let message = messages[key] || messages.general;
  
  // Replace placeholders
  Object.keys(replacements).forEach(placeholder => {
    message = message.replace(`{${placeholder}}`, replacements[placeholder]);
  });
  
  return message;
};

// Prompt templates
const PROMPTS = {
  greeting: (language = LANGUAGES.VI) => {
    if (language === LANGUAGES.EN) {
      return `
You are a professional virtual assistant for ${SHOP_CONFIG.name} Shop - where the super cute owner ${SHOP_CONFIG.owner} runs the business.

Create an impressive greeting and introduce yourself as a shopping expert consultant.

Requirements:
- Language: Natural English
- Style: Friendly, professional, energetic
- Create excitement and readiness to help
      `.trim();
    }
    
    return `
Bạn là trợ lý ảo chuyên nghiệp của Shop ${SHOP_CONFIG.name} - ${SHOP_CONFIG.description} tên là ${SHOP_CONFIG.owner}.

Hãy chào hỏi thật ấn tượng và giới thiệu bản thân như một chuyên gia tư vấn mua sắm.

Yêu cầu:
- Ngôn ngữ: Tiếng Việt tự nhiên
- Phong cách: Thân thiện, chuyên nghiệp, năng động
- Tạo cảm giác hứng thú và sẵn sàng hỗ trợ
    `.trim();
  },

  product: (context, question, language = LANGUAGES.VI) => {
    if (language === LANGUAGES.EN) {
      return `
Role: You are a professional sales assistant for ${SHOP_CONFIG.name} Shop

Product Information:
${context}

Customer Question: "${question}"

Response Guidelines:
1. Analyze the question and find relevant information
2. Answer accurately based on available data
3. If information is missing, acknowledge and suggest contacting us
4. Use natural, friendly English
5. Length: Concise, straight to the point
6. Do not fabricate information not in the data

Response Format:
- Accurate product information
- Pricing (if available)
- Key features
- Advice/suggestions (if appropriate)
      `.trim();
    }
    
    return `
Vai trò: Bạn là trợ lý bán hàng chuyên nghiệp của Shop ${SHOP_CONFIG.name}

Thông tin sản phẩm:
${context}

Câu hỏi khách hàng: "${question}"

Hướng dẫn trả lời:
1. Phân tích câu hỏi và tìm thông tin phù hợp
2. Trả lời chính xác dựa trên dữ liệu có sẵn
3. Nếu thiếu thông tin, thừa nhận và gợi ý liên hệ
4. Sử dụng tiếng Việt tự nhiên, thân thiện
5. Độ dài: Ngắn gọn, đi thẳng vào vấn đề
6. Không bịa đặt thông tin không có trong dữ liệu
7. Nhớ nịn khách cho tôi, nói những lời thật cuốn để dụ khách mua
8. Sai thì phải xin lỗi đồ nhé
9. Gợi ý món thì kể ra các món ngon ngon

Định dạng trả lời:
- Thông tin chính xác về sản phẩm
- Giá cả (nếu có)
- Đặc điểm nổi bật
- Lời khuyên/gợi ý (nếu phù hợp)
    `.trim();
  },

  policy: (fact, question, language = LANGUAGES.VI) => {
    if (language === LANGUAGES.EN) {
      return `
Role: You are a customer service specialist for an e-commerce application

Customer Question: "${question}"

Official Information: "${fact}"

Response Requirements:
1. Base answer entirely on provided information
2. Explain clearly and understandably
3. Professional, courteous attitude
4. Natural, standard English
5. Logical structure with important highlights
6. Do not add information not in the source data
7. This is Beverage shop

Format:
- Direct answer to the question
- Detailed explanation (if needed)
- Specific instructions (if available)
      `.trim();
    }
    
    return `
Vai trò: Bạn là chuyên viên CSKH của ứng dụng thương mại điện tử

Câu hỏi khách hàng: "${question}"

Thông tin chính thức: "${fact}"

Yêu cầu trả lời:
1. Dựa hoàn toàn vào thông tin được cung cấp
2. Giải thích rõ ràng, dễ hiểu
3. Thái độ lịch sự, chuyên nghiệp
4. Tiếng Việt chuẩn, tự nhiên
5. Cấu trúc logic, có điểm nhấn quan trọng
6. Không thêm thông tin không có trong dữ liệu gốc
7. Cửa hàng bán nước uống

Định dạng:
- Trả lời trực tiếp câu hỏi
- Giải thích chi tiết (nếu cần)
- Hướng dẫn cụ thể (nếu có)
    `.trim();
  }
};

// Core service functions
class ChatbotService {
  /**
   * Generate AI response with error handling
   * @param {string} prompt - The prompt to send to AI
   * @param {string} fallbackMessage - Fallback message if AI fails
   * @param {string} language - Language for response
   * @returns {Promise<string>} AI generated response
   */
  async generateResponse(prompt, fallbackMessage = null, language = LANGUAGES.VI) {
    try {
      const result = await model.generateContent(prompt);
      const response = await result.response.text();
      return response || fallbackMessage || getMessage('general', language);
    } catch (error) {
      console.error('Error generating AI response:', error);
      return fallbackMessage || getMessage('general', language);
    }
  }

  /**
   * Generate greeting response
   * @param {string} language - Language for greeting
   * @returns {Promise<string>} Greeting message
   */
  async generateGreeting(language = LANGUAGES.VI) {
    const prompt = PROMPTS.greeting(language);
    const fallbackMessage = language === LANGUAGES.EN 
      ? `Hello! I'm the assistant of ${SHOP_CONFIG.name} Shop. I can help you find products and provide shopping advice. How can I help you?`
      : `Xin chào! Tôi là trợ lý của Shop ${SHOP_CONFIG.name}. Tôi có thể giúp bạn tìm sản phẩm và tư vấn mua sắm. Bạn cần hỗ trợ gì ạ?`;
    
    return await this.generateResponse(prompt, fallbackMessage, language);
  }

  /**
   * Generate product-related answer
   * @param {string} context - Product information context
   * @param {string} question - User's question
   * @param {string} language - Language for response
   * @returns {Promise<string>} Product answer
   */
  async generateProductAnswer(context, question, language = LANGUAGES.VI) {
    if (!context || !question) {
      return getMessage('need_more_info', language);
    }

    const sanitizedQuestion = sanitizeInput(question);
    const prompt = PROMPTS.product(context, sanitizedQuestion, language);
    
    return await this.generateResponse(
      prompt,
      getMessage('no_product', language),
      language
    );
  }

  /**
   * Generate policy/FAQ answer
   * @param {string} fact - Policy information
   * @param {string} question - User's question
   * @param {string} language - Language for response
   * @returns {Promise<string>} Policy answer
   */
  async generatePolicyAnswer(fact, question, language = LANGUAGES.VI) {
    if (!fact || !question) {
      return getMessage('need_more_info', language);
    }

    const sanitizedQuestion = sanitizeInput(question);
    const prompt = PROMPTS.policy(fact, sanitizedQuestion, language);
    
    return await this.generateResponse(
      prompt,
      getMessage('no_policy', language),
      language
    );
  }

  /**
   * Search products using Pinecone vector database
   * @param {string} queryText - Search query
   * @param {string} language - Language for response (auto-detected if not provided)
   * @returns {Promise<string>} Search results with AI answer
   */
  async searchProducts(queryText, language = null) {
    try {
      if (!queryText) {
        const detectedLang = language || LANGUAGES.VI;
        return getMessage('empty_query', detectedLang);
      }

      const sanitizedQuery = sanitizeInput(queryText);
      const detectedLanguage = language || detectLanguage(sanitizedQuery);

      // Check if it's a greeting
      if (isGreeting(sanitizedQuery, detectedLanguage)) {
        return await this.generateGreeting(detectedLanguage);
      }

      // Search in Pinecone
      const index = pineconeIndex.namespace(SHOP_CONFIG.namespace);
      const searchResults = await index.searchRecords({
        query: { 
          topK: SHOP_CONFIG.maxResults, 
          inputs: { text: sanitizedQuery } 
        },
      });

      // Extract and combine search results
      if (!searchResults?.result?.hits?.length) {
        return getMessage('no_search_results', detectedLanguage, { query: sanitizedQuery });
      }

      const productChunks = searchResults.result.hits
        .map(hit => hit.fields?.chunk_text)
        .filter(chunk => chunk)
        .join("\n---\n");

      // Generate AI answer based on search results
      return await this.generateProductAnswer(productChunks, sanitizedQuery, detectedLanguage);

    } catch (error) {
      console.error('Error searching products:', error);
      const errorLanguage = language || detectLanguage(queryText) || LANGUAGES.VI;
      return getMessage('search_error', errorLanguage);
    }
  }

  /**
   * Main chat handler - determines response type and generates appropriate answer
   * @param {string} userMessage - User's message
   * @param {string} messageType - Type of message (product, policy, etc.)
   * @param {Object} additionalData - Additional context data
   * @param {string} language - Language preference (auto-detected if not provided)
   * @returns {Promise<Object>} Response object with answer and metadata
   */
  async handleChat(userMessage, messageType = RESPONSE_TYPES.PRODUCT, additionalData = {}, language = null) {
    try {
      const sanitizedMessage = sanitizeInput(userMessage);
      
      if (!sanitizedMessage) {
        const detectedLang = language || LANGUAGES.VI;
        return {
          answer: getMessage('empty_question', detectedLang),
          type: RESPONSE_TYPES.ERROR,
          language: detectedLang,
          timestamp: new Date().toISOString()
        };
      }

      // Auto-detect language if not provided
      const detectedLanguage = language || detectLanguage(sanitizedMessage);
      
      let answer;
      let responseType = messageType;

      // Determine response type and generate answer
      switch (messageType) {
        case RESPONSE_TYPES.GREETING:
          answer = await this.generateGreeting(detectedLanguage);
          break;
        
        case RESPONSE_TYPES.POLICY:
          answer = await this.generatePolicyAnswer(
            additionalData.fact, 
            sanitizedMessage,
            detectedLanguage
          );
          break;
        
        case RESPONSE_TYPES.PRODUCT:
        default:
          // Check if greeting first
          if (isGreeting(sanitizedMessage, detectedLanguage)) {
            answer = await this.generateGreeting(detectedLanguage);
            responseType = RESPONSE_TYPES.GREETING;
          } else {
            answer = await this.searchProducts(sanitizedMessage, detectedLanguage);
          }
          break;
      }

      return {
        answer,
        type: responseType,
        language: detectedLanguage,
        timestamp: new Date().toISOString(),
        query: sanitizedMessage
      };

    } catch (error) {
      console.error('Error in handleChat:', error);
      const errorLanguage = language || detectLanguage(userMessage) || LANGUAGES.VI;
      return {
        answer: getMessage('general_error', errorLanguage),
        type: RESPONSE_TYPES.ERROR,
        language: errorLanguage,
        timestamp: new Date().toISOString(),
        error: error.message
      };
    }
  }
}

// Create singleton instance
const chatbotService = new ChatbotService();

// Export functions (maintain backward compatibility)
module.exports = {
  // Main service instance
  chatbotService,
  
  // Individual functions for backward compatibility
  searchProducts: (queryText) => chatbotService.searchProducts(queryText),
  generateProductAnswer: (context, question) => chatbotService.generateProductAnswer(context, question),
  generatePolicyAnswer: (fact, question) => chatbotService.generatePolicyAnswer(fact, question),
  
  // New enhanced function
  handleChat: (userMessage, messageType, additionalData) => 
    chatbotService.handleChat(userMessage, messageType, additionalData),
  
  // Constants for external use
  RESPONSE_TYPES,
  SHOP_CONFIG
};