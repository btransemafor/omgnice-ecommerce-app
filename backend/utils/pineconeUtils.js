

const { Pinecone } = require('@pinecone-database/pinecone');
require('dotenv').config();

const pinecone = new Pinecone({ apiKey: process.env.PINECONE_API_KEY  || "pcsk_4N4TfD_BKFD9d8Lw4F2xty3tv4K6LuMU8awt9b1QUQTK8F4MkSf9QjxRyMXDJxyR7QTqm9"});
const pineconeIndex = pinecone.index(process.env.PINECONE_INDEX_NAME || "idx-products");

module.exports = { pinecone, pineconeIndex };
