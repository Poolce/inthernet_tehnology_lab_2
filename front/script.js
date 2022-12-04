let CURRENT_INTERVAL;
let CURRENT_ID;
let CURRENT_TIME;
let CURRENT_DATE;

//AJAX отправка результата
async function send_result()
{
    try{
    let res = await $.post('http://localhost:8000/send_res',
    {
        id: CURRENT_ID,
        time: CURRENT_TIME,
        date: document.getElementById('date').value,
        user_name: document.getElementById('name').value
    });
    if(res=='ok')
    alert(`Вы записались ${CURRENT_DATE} на ${CURRENT_TIME}`);
    get_busy_time(CURRENT_DATE);
    }catch(err){
        alert(err)
    }
}



//AJAX получение таблицы для текущей даты

async function get_busy_time(c_date)
{
    try{CURRENT_DATE = c_date;
    let busy_time = await $.post('http://localhost:8000/get_busy',{date: c_date});
    get_time(busy_time);
}catch(err){
    alert(err);
}
}

//AJAX получение продолжительности для текущей процедуры
async function get_current_duration(c_name)
{
   try{ 
    let duration = await $.post('http://localhost:8000/get_duration',{name: c_name});
    CURRENT_ID = duration[0].serv_id;
    CURRENT_INTERVAL = parse_time(duration[0].duration);
    }
    catch(err){
        alert(err)
    }
}

function get_time(busy_time)
{
    //Формирование таблицы времени
    let table = document.getElementById("time_table");
    table.innerHTML = '';
    curr_time = 480;
    for(i=0;i<busy_time.length;i++)
    {
        start_time = parse_time(busy_time[i].start_time)
        end_time = parse_time(busy_time[i].end_time)
        while(curr_time<start_time)
        {
            const $el = document.createElement('td');
            $el.style = 'background-color: green; height: 30px; width: 30px;';
            $el.classList.add('free')
            $el.setAttribute('name', curr_time);
            table.appendChild($el);
            curr_time+=10;
        }
        while(curr_time<end_time)
        {
            const $el = document.createElement('td');
            $el.style = 'background-color: red; height: 30px; width: 30px;';
            table.appendChild($el);
            curr_time+=10;
        }
    }
    while(curr_time<1080)
    {
        const $el = document.createElement('td');
        $el.style = 'background-color: green; height: 30px; width: 30px;';
        $el.setAttribute('name', curr_time);
        $el.classList.add('free')
        table.appendChild($el);
        curr_time+=10;
    }

    //Динамика таблицы времени
    $(function(){

        $(".free").mouseenter(function() {
            flag = true;
            curr_time = this.getAttribute('Name');
            document.getElementById('time').textContent = `Выберете время: ${time_to_text(curr_time)}`;
            console.log(CURRENT_INTERVAL)
            
            for(i = 0;i<CURRENT_INTERVAL;i+=10)
            {
                if(!document.getElementsByName(Number(curr_time)+i)[0])
                flag = false;
            }
            if(flag)
            {
                for(i = 0;i<CURRENT_INTERVAL;i+=10)
                {
                    document.getElementsByName(Number(curr_time)+i)[0].style = 'background-color: blue; height: 30px; width: 30px;';
                }
            }
            else{
                i=0;
                while(document.getElementsByName(Number(curr_time)+i)[0])
                {
                    document.getElementsByName(Number(curr_time)+i)[0].style = 'background-color: red; height: 30px; width: 30px;';
                    i+=10;
                }
            }
        });

        $(".free").click(function() {
            flag = true;
            for(i = 0;i<CURRENT_INTERVAL;i+=10)
            {
                if(!document.getElementsByName(Number(curr_time)+i)[0])
                flag = false;
            }
            if(flag)
            {
                for(i = 0;i<CURRENT_INTERVAL;i+=10)
                {
                    document.getElementsByName(Number(curr_time)+i)[0].style = 'background-color: grey; height: 30px; width: 30px;';
                }
                CURRENT_TIME = time_to_text(curr_time);
                document.getElementById('curr_time').textContent = `Выберанное время: ${time_to_text(curr_time)}`;
            }
        });

        $(".free").mouseleave(function() {
            document.getElementById('time').textContent = "Выберете время: ";
            for(i=0;i<document.getElementsByClassName("free").length;i++)
            {
              document.getElementsByClassName('free')[i].style = 'background-color: green; height: 30px; width: 30px;';
            }
        });
    });
}
