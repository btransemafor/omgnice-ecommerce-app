const { where } = require('sequelize');
const {db} = require('../models/index'); 

/*
// GET ALL USERS
const getAllUsers = async () => {
  return await User.findAll({attributes: {
    exclude: ['password']
  }})
}; 

*/ 



const getAllCategories = async (callback) => {
    try {
        categories = await db.category.findAll(); 
        return callback(null, {
            success: true, 
            message: "Lay Danh Sach Category thanh cong", 
            data: categories
        })
    }
    catch(error) {
        return callback(error); 
    }
    
}

const updateCategory = async (param, callback) => {
    try {
      const id = param.id;
      const updateData = param.updateData;
  
      // Kiểm tra category có tồn tại không
      const category = await db.category.findOne({ where: { id } });
  
      if (!category) {
        return callback(null, {
          success: false,
          message: "Category không tồn tại"
        });
      }
  
      // Cập nhật category
      const [affectedRows] = await db.category.update(updateData, {
        where: { id }
      });
  
      if (affectedRows === 0) {
        return callback(null, {
          success: false,
          message: "Không có thay đổi nào"
        });
      }
  
      return callback(null, {
        success: true,
        message: "Cập nhật danh mục thành công"
      });
  
    } catch (e) {
      return callback(e);
    }
  };
  

// -------------------------- Them Category ---------------------- // 
const addCategory = async (name, callback) => {
    try {
      // Kiểm tra xem category đã tồn tại chưa
      const existingCategory = await db.category.findOne({ where: { category_name: name } });
  
      if (existingCategory) {
        return callback(null, {
          success: false,
          message: "Tên danh mục đã tồn tại trong hệ thống"
        });
      }
  
      // Thêm mới category
      await db.category.create({ category_name: name });
      console.log("Create Category Successful");
  
      return callback(null, {
        success: true,
        message: "Thêm danh mục thành công"
      });
  
    } catch (e) {
      return callback(e);
    }
  };



  // -------------------------------- Delete Category -------------------------- // 

const deleteCategory = async (name, callback) => {
    try {
      // Kiểm tra xem category có tồn tại không
      const category = await db.category.findOne({ where: { category_name: name } });
  
      if (!category) {
        return callback(null, {
          success: false,
          message: "Danh mục không tồn tại trong hệ thống"
        });
      }
  
      // Xoá category
      await db.category.destroy({ where: { category_name: name } });
  
      return callback(null, {
        success: true,
        message: `Đã xoá danh mục: ${name}`
      });
  
    } catch (err) {
      return callback(err);
    }
  };
  
/*
Post.destroy({
    where: {
      authorId: {
        [Op.or]: [12, 13],
      },
    },
  });

  */ 


module.exports = {
    getAllCategories, 
    updateCategory, 
    addCategory, 
    deleteCategory
}