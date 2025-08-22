/* // ================================
// 4. chatbot.controller.js
// ================================
const path = require('path');
const fs = require('fs');
const {
  searchProducts,
  generatePolicyAnswer,
} = require('../services/chatbot.services');

const faqPath = path.join(__dirname, '../data/faq.json');
const faqData = JSON.parse(fs.readFileSync(faqPath, 'utf-8'));

// --------------------
// 1. Phân loại câu hỏi
// --------------------
function classifyQuery(query) {
  const lower = query.toLowerCase();
  const statisticalKeywords = ['bao nhiêu', 'giá cao', 'bán chạy', 'giảm giá', 'danh mục', 'trung bình'];
  const policyKeywords = ['quy trình', 'mua hàng', 'xóa tài khoản', 'hủy đơn', 'trả hàng', 'đổi hàng', 'tài khoản' , 'vận chuyển'];

  if (statisticalKeywords.some(k => lower.includes(k))) return 'statistical';
  if (policyKeywords.some(k => lower.includes(k))) return 'policy';
  return 'semantic';
}

// -----------------------------
// 2. Tìm câu trả lời từ FAQ JSON
// -----------------------------
function findMatchedFAQ(query) {
  const lower = query.toLowerCase();
  return faqData.find(item => item.keywords.some(k => lower.includes(k)));
}

// --------------------
// 3. Xử lý chính sách (FAQ)
// --------------------
async function handlePolicyQuery(query) {
  const matched = findMatchedFAQ(query);
  if (!matched) {
    return "Xin lỗi, tôi chưa có câu trả lời cho câu hỏi này. Bạn có thể liên hệ CSKH để được hỗ trợ.";
  }
  return await generatePolicyAnswer(matched.answer, query);
}

// ------------------
// 4. Hàm chính export
// ------------------
async function askChatbot(req, res) {
  const { query } = req.body;
  if (!query) {
    return res.status(400).json({ success: false, message: 'Missing query' });
  }

  try {
    const type = classifyQuery(query);
    let result;

    if (type === 'semantic') {
      result = await searchProducts(query);
    } else if (type === 'policy') {
      result = await handlePolicyQuery(query);
    } else {
      result = 'Chức năng thống kê sẽ được tích hợp sắp tới.';
    }

    res.json({ success: true, result });
  } catch (err) {
    console.error('Chatbot error:', err);
    res.status(500).json({ success: false, message: 'Lỗi hệ thống khi xử lý chatbot.' });
  }
}

module.exports = { askChatbot };
 */


// ================================
// 4. chatbot.controller.js - Enhanced Version
// ================================
const path = require('path');
const fs = require('fs');
const {
  searchProducts,
  generatePolicyAnswer,
} = require('../services/chatbot.services');

const faqPath = path.join(__dirname, '../data/faq.json');
const faqData = JSON.parse(fs.readFileSync(faqPath, 'utf-8'));

// --------------------
// 1. Phân loại câu hỏi (Enhanced)
// --------------------
function classifyQuery(query) {
  const lower = query.toLowerCase();
  
  // Mở rộng từ khóa thống kê
  const statisticalKeywords = [
    'giá cao', 'bán chạy', 'giảm giá', 'danh mục', 'trung bình',
    'số lượng', 'thống kê', 'top', 'nhiều nhất', 'ít nhất', 'phổ biến',
    'tổng cộng', 'đếm', 'count', 'average', 'max', 'min', 'bestseller'
  ];
  
  // Mở rộng từ khóa chính sách
  const policyKeywords = [
    'quy trình', 'mua hàng', 'xóa tài khoản', 'hủy đơn', 'trả hàng', 'đổi hàng', 
    'tài khoản', 'vận chuyển', 'thanh toán', 'payment', 'bảo hành', 'warranty',
    'liên hệ', 'hỗ trợ', 'support', 'cskh', 'khuyến mãi', 'coupon', 'voucher',
    'theo dõi', 'tracking', 'giao hàng', 'delivery', 'shipping', 'đăng nhập',
    'login', 'mật khẩu', 'password', 'đổi trả', 'return', 'exchange'
  ];

  // Từ khóa chào hỏi
  const greetingKeywords = [
    'xin chào', 'hello', 'hi', 'chào', 'good morning', 'good afternoon',
    'good evening', 'chào bạn', 'hey', 'hế lô'
  ];

  // Từ khóa tạm biệt
  const farewell_keywords = [
    'tạm biệt', 'bye', 'goodbye', 'see you', 'chào tạm biệt',
    'hẹn gặp lại', 'cảm ơn', 'thank you', 'thanks'
  ];

  if (greetingKeywords.some(k => lower.includes(k))) return 'greeting';
  if (farewell_keywords.some(k => lower.includes(k))) return 'farewell';
  if (statisticalKeywords.some(k => lower.includes(k))) return 'statistical';
  if (policyKeywords.some(k => lower.includes(k))) return 'policy';
  
  return 'semantic';
}

// -----------------------------
// 2. Tìm câu trả lời từ FAQ JSON (Enhanced)
// -----------------------------
function findMatchedFAQ(query) {
  const lower = query.toLowerCase();
  
  // Tìm match tốt nhất với nhiều keyword
  let bestMatch = null;
  let maxMatches = 0;
  
  for (const item of faqData) {
    const matchedKeywords = item.keywords.filter(k => lower.includes(k));
    if (matchedKeywords.length > maxMatches) {
      maxMatches = matchedKeywords.length;
      bestMatch = item;
    }
  }
  
  // Nếu không có match với nhiều keyword, tìm match đầu tiên
  if (!bestMatch) {
    bestMatch = faqData.find(item => item.keywords.some(k => lower.includes(k)));
  }
  
  return bestMatch;
}

// --------------------
// 3. Xử lý chào hỏi
// --------------------
function handleGreeting(query) {
  const greetings = [
    "Chào cục cưng nha hehe ! 💖 Tôi là đệ tử guột của cửa hàng OMGNICE, nơi bạn sẽ tìm thấy những ly nước tuyệt vời nhất do người chủ siêu cấp cute 😍 tạo ra. Tôi có thể giúp bạn:  " +
    "🍹 Tìm món nước yêu thích  " +  
    "📞 Cung cấp một vài thông tin liên quan\n*   " +  

    "Bạn muốn thưởng thức gì hôm nay nhanh chân lẹ tay lên ...? 😄  "  
  ];

  return greetings[Math.floor(Math.random() * greetings.length)];
}


// --------------------
// 4. Xử lý tạm biệt
// --------------------
function handleFarewell(query) {
  const farewells = [
    "Cảm ơn bạn đã sử dụng dịch vụ! Chúc bạn một ngày tốt lành! 😊\n" +
    "Nếu cần hỗ trợ thêm, đừng ngần ngại liên hệ với chúng tôi nhé!",
    
    "Tạm biệt và cảm ơn bạn! 👋\n" +
    "Hy vọng đã giúp ích được cho bạn. Hẹn gặp lại!"
  ];
  
  return farewells[Math.floor(Math.random() * farewells.length)];
}

// --------------------
// 5. Xử lý chính sách (FAQ) - Enhanced
// --------------------
async function handlePolicyQuery(query) {
  const matched = findMatchedFAQ(query);
  if (!matched) {
    return "Xin lỗi, tôi chưa có thông tin về vấn đề này. Bạn có thể:\n\n" +
           "📞 Liên hệ CSKH:\n" +
           "• Hotline: 0338498306 (8:00-22:00)\n" +
           "• Email: omgniceten@gmail.com\n" +
           "• Chat trực tuyến trong app\n\n" +
           "Hoặc thử hỏi với từ khóa khác nhé!";
  }
  return await generatePolicyAnswer(matched.answer, query);
}

// --------------------
// 6. Xử lý thống kê (Enhanced)
// --------------------
async function handleStatisticalQuery(query) {
  const lower = query.toLowerCase();
  
  
  return " **Chức năng thống kê:**\n\n" +
         "Tính năng thống kê chi tiết sẽ sớm được ra mắt!\n" +
         "Cảm ơn bạn đã quan tâm. Hãy theo dõi để cập nhật nhé!";
}

// --------------------
// 7. Validate và làm sạch input
// --------------------
function validateAndCleanInput(query) {
  if (!query || typeof query !== 'string') {
    return { isValid: false, cleaned: '', error: 'Vui lòng nhập câu hỏi hợp lệ.' };
  }
  
  const cleaned = query.trim();
  if (cleaned.length === 0) {
    return { isValid: false, cleaned: '', error: 'Câu hỏi không được để trống.' };
  }
  
  if (cleaned.length > 500) {
    return { isValid: false, cleaned: '', error: 'Câu hỏi quá dài (tối đa 500 ký tự).' };
  }
  
  return { isValid: true, cleaned, error: null };
}

// --------------------
// 8. Log query cho analytics
// --------------------
function logQuery(query, type, success = true) {
  const timestamp = new Date().toISOString();
  const logData = {
    timestamp,
    query: query.substring(0, 100), // Chỉ log 100 ký tự đầu
    type,
    success,
    ip: 'xxx.xxx.xxx.xxx' // Có thể lấy từ req.ip
  };
  
  // Có thể ghi vào file hoặc database
  console.log('Query Log:', JSON.stringify(logData));
}

// ------------------
// 9. Hàm chính export (Enhanced)
// ------------------
async function askChatbot(req, res) {
  const { query } = req.body;
  
  // Validate input
  const validation = validateAndCleanInput(query);
  if (!validation.isValid) {
    return res.status(400).json({ 
      success: false, 
      message: validation.error 
    });
  }

  const cleanedQuery = validation.cleaned;
  let result;
  let queryType;

  try {
    queryType = classifyQuery(cleanedQuery);
    
    // Xử lý theo loại query
    switch (queryType) {
      case 'greeting':
        result = handleGreeting(cleanedQuery);
        break; 
        
      case 'farewell':
        result = handleFarewell(cleanedQuery);
        break;
        
      case 'semantic':
        result = await searchProducts(cleanedQuery);
        break;
        
      case 'policy':
        result = await handlePolicyQuery(cleanedQuery);
        break;
        
      case 'statistical':
        result = await handleStatisticalQuery(cleanedQuery);
        break;
        
      default:
        result = "Xin lỗi, tôi không hiểu câu hỏi của bạn. " +
                "Vui lòng thử lại với từ khóa rõ ràng hơn hoặc liên hệ CSKH để được hỗ trợ.";
        queryType = 'unknown';
    }

    // Log successful query
    logQuery(cleanedQuery, queryType, true);

    res.json({ 
      success: true, 
      result,
      queryType, // Để debug/analytics
      timestamp: new Date().toISOString()
    });
    
  } catch (err) {
    console.error('Chatbot error:', err);
    
    // Log failed query
    logQuery(cleanedQuery, queryType || 'error', false);
    
    res.status(500).json({ 
      success: false, 
      message: 'Xin lỗi, hệ thống đang gặp sự cố. Vui lòng thử lại sau hoặc liên hệ CSKH.',
      errorCode: 'SYSTEM_ERROR'
    });
  }
}

// ------------------
// 10. Health check endpoint
// ------------------
async function healthCheck(req, res) {
  try {
    // Kiểm tra FAQ data
    const faqExists = fs.existsSync(faqPath);
    const faqCount = faqExists ? faqData.length : 0;
    
    res.json({
      success: true,
      status: 'healthy',
      faqDataLoaded: faqExists,
      faqCount,
      timestamp: new Date().toISOString()
    });
  } catch (err) {
    res.status(500).json({
      success: false,
      status: 'unhealthy',
      error: err.message
    });
  }
}

module.exports = { 
  askChatbot,
  healthCheck 
};