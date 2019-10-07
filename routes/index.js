const express = require('express');
const router = express.Router();

var users = require('../controllers/user');

router.post('/users', users.registerUser); // add or register new user
router.post('/login', users.loginUser); // login
router.delete('/users/:id', users.deleteUser); // delete a single user
router.get('/users?', users.listUsers); // list all users
router.patch('/users/:id', users.updateUser); // update a single user

module.exports = router;
