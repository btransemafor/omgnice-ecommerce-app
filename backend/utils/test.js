const { testEmbedding, queryPinecone, indexes } = require('./pineconeUtils');

async function testRAG() {
  try {
    const query = "What are your best products?";
    console.log(`Testing RAG with query: "${query}"`);
    
    // Get embedding (will try all methods)
    const embedding = await testEmbedding(query);
    console.log("Generated embedding successfully");
    
    // Query Pinecone
    const results = await queryPinecone(indexes.products, embedding);
    console.log("Pinecone results:", results);
  } catch (err) {
    console.error("Test failed:", err);
  }
}

testRAG();