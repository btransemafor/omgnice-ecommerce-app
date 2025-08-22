// testQuery.js
const { Pinecone } = require('@pinecone-database/pinecone');
require('dotenv').config();

(async () => {
  const pinecone = new Pinecone({ apiKey: process.env.PINECONE_API_KEY });
  const index = pinecone.Index('idx_products');

  const query = "Sản phẩm nào giảm giá nhiều nhất trong skincare?";
  const embedded = await pinecone.inference.embed({
    model: "llama-text-embed-v2",
    inputs: [query],
    parameters: { input_type: "query" }
  });

  const result = await index.query({
    vector: embedded[0].values,
    topK: 3,
    namespace: "products",
    includeMetadata: true
  });

  console.log("🔍 Kết quả:");
  result.matches.forEach((m, i) => {
    console.log(`[${i + 1}] ${m.metadata.name} (${m.metadata.price} VND): ${m.metadata.content}`);
  });
})();
