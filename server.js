const express = require('express');
const bodyParser = require('body-parser');
var cors = require('cors');
var port = process.env.PORT || 3000;
const app = express();
const routes = require('./routes/index');

app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use('/api', routes);

app.listen(port, () => console.log('Server is up and listening on port :' + port + '!'));

module.exports = app;