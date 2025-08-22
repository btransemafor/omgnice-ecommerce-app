const bannerService = require("../services/banner.services");
const getbanners = async (req, res) => {
  try {
    bannerService.getbanners((err, result) => {
      if (err) {
        return res.status(500).json(err);
      }
      return res.status(200).json(result);
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: "Lỗi máy chủ!",
      error: error.message,
    });
  }
};

const createBanner = async (req, res) => {
  const content = req.body;
  console.log('[📥 Banner Content]', content);

  bannerService.createBanner(content, (error, result) => {
    if (error) {
      return res.status(500).json({ success: false, message: 'Failed to create banner', error });
    }

    return res.status(200).json({ success: true, message: 'Banner created successfully', data: result });
  });
};


const deleteBanner = async (req, res) => {
  const banner_id = req.params.id; 
  console.log(`Xoa banner ${banner_id}`)
  bannerService.deleteBanner(banner_id, (error, result) => {
    if (error) {
      return res.status(500).json({ success: false, message: 'Failed to delete banner', error });
    }

    return res.status(200).json({ success: true, message: 'Banner deleted successfully', data: result });
  })
}

module.exports = {
  getbanners,
  createBanner, 
  deleteBanner
};
