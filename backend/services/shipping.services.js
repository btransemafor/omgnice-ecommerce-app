const { db } = require('../models/index');

const getShippingMethod = async (callback) => {
  try {
    const shipping = await db.shipping_method.findAll();

    if (!shipping || shipping.length === 0) {
      return callback(null, {
        success: false,
        message: 'No shipping methods found',
      });
    }

    return callback(null, {
      success: true,
      message: 'Fetched shipping methods successfully.',
      data: shipping,
    });
  } catch (error) {
    return callback(error);
  }
};

module.exports = {
  getShippingMethod,
};
