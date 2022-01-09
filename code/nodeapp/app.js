const mysql = require('mysql')
const express = require("express")
const app = express()
const port = 3000
const path = require('path')
const ejs = require("ejs")
const bodyParser = require("body-parser")
const log = console.log


var pool        = mysql.createPool({
    connectionLimit : 10,
    host            : 'localhost',
    user            : 'root',
    password        : 'jade12',
    database        : 'TODO'
});
app.set('view engine', 'html');
app.engine('html', require('ejs').renderFile);
app.use(bodyParser.urlencoded({extended:false}))
app.use(bodyParser.json())

app.post('/novatarefa',(req,res)=>{
    log(req.body);
    var name = req.body["name"]
    var description = req.body["description"]

    var sql = "INSERT INTO task (name,description) VALUES ('"+name+"','"+description+"')"
    log(sql)
    pool.getConnection((err,connection)=>{
        connection.query(sql,(err,rows)=>{
            connection.release()
            if(err) throw err
        })
    })
    res.redirect("/")

})


app.get("/", (req,res)=>{

    pool.getConnection((err,connection)=>{
        connection.query("SELECT * FROM task",(err,rows)=>{
            connection.release();
            if(err) throw err;
            var data = rows;
            res.render("index.html",{data:data})

        })

    })

}) 
app.listen(port,()=>{
    log('Example app listening at http://localhost:'+port)
})
