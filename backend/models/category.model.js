// models/category.model.js
const { Sequelize } = require("sequelize");
const sequelize = require("../config/db.config").sequelize;
const Role = require("./role.model");

module.exports = (sequelize, Sequelize) => {
    const Category = sequelize.define('Category', {
      id: {
        type:  Sequelize.INTEGER,
        primaryKey: true,
        autoIncrement: true
      },
      category_name: {
        type:  Sequelize.STRING,
        allowNull: false
      },
    
    }, {
      tableName: 'category',
      timestamps: false
    });
  
    return Category;
  };
  


  