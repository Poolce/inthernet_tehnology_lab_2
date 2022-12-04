const db = require('./db-connect');
const Express = require('express');
const ph = require("path");
const app = Express();
var bodyParser = require('body-parser');

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
app.use(Express.static('front'));



app.post('/get_busy', async (req, res) => {
    try
    {
        date = req.body.date;
        let s = await db.get_busy(date);
        res.send(s);
    }
    catch(err)
    {
        res.end(JSON.stringify(err))
    }
});

app.post('/get_duration', async (req, res) => {
    try
    {
        c_name = req.body.name;
        let s = await db.get_duration(c_name);
        res.send(s);
    }
    catch(err)
    {
        res.end(JSON.stringify(err))
    }
});

app.post('/send_res', async (req, res) => {
    try
    {        
        u_name = req.body.user_name;
        date = req.body.date;
        с_time = req.body.time;
        c_id = req.body.id;
        console.log()
        let s = await db.sign_up(с_time,date,c_id,u_name);
        res.send(s);
    }
    catch(err)
    {
        res.end(JSON.stringify(err))
    }
});

app.post('/get_tags', async (req, res) => {
    try
    {
        let s = await db.get_tags();
        res.send(s);
    }
    catch(err)
    {
        res.end(JSON.stringify(err))
    }
});

app.get('/', async (req, res) => {
    try
    {
        res.sendFile(ph.join(__dirname+'/front/index.html'))
    }
    catch(err)
    {
        res.end(JSON.stringify(err))
    }
});

app.listen(8000, () => {
    console.log('Application listening on port 8000!');
});