/* // Import the Pinecone library
import { Pinecone } from '@pinecone-database/pinecone'

// Initialize a Pinecone client with your API key
const pc = new Pinecone({ apiKey: 'pcsk_71CqHk_NQT5w6WF2vN8NPTeMzZVpb8Emifnn6rdQd2EZZRiiTa7XfjV9JybvkDMyEKkG92' });

// Create a dense index with integrated embedding
const indexName = 'index-product';
await pc.createIndexForModel({
  name: indexName,
  cloud: 'aws',
  region: 'us-east-1',
  embed: {
    model: 'llama-text-embed-v2',
    fieldMap: { text: 'chunk_text' },
  },
  waitUntilReady: true,
});
 */

const { Pinecone } = require('@pinecone-database/pinecone');
require('dotenv').config();
// createIndex.js

const pc = new Pinecone({ apiKey: process.env.PINECONE_API_KEY });

async function createIndex() {
  try {
    await pc.createIndexForModel({
      name: process.env.PINECONE_INDEX_NAME,
      cloud: 'aws',
      region: 'us-east-1',
      embed: {
        model: 'llama-text-embed-v2',
        fieldMap: { text: 'chunk_text' }, // Dữ liệu sẽ embedding từ field này
      },
      waitUntilReady: true,
    });

    console.log('✅ Pinecone index created with integrated model.');
  } catch (err) {
    console.error('❌ Failed to create index:', err.message);
  }
}

createIndex();
