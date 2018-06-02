const express = require('express')
const app = express()

var count = 0;

app.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});

app.get('/counter', (req, res) => res.send(String(++count)))

app.post('/counter/:value', (req, res) => {
    count = req.params.value
    res.send(String(count))
})

app.listen(3000, () => console.log('App listening on port 3000!'))