// ================================
// testSyncProducts.js
// ================================
const { syncProducts } = require('../services/sync.services');
require('dotenv').config();
(async () => {
  try {
    const syncedCount = await syncProducts({

    });

    console.log(`Test hoàn tất. Số sản phẩm được sync: ${syncedCount}`);
  } catch (error) {
    console.error('Lỗi khi test syncProducts:', error.message);
  }
})();
