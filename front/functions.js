function parse_time(str)
{
    let int_res;
    arr = str.split(':')
    int_res = (arr[0]*60+arr[1]*1);
    return int_res;
}    
function time_to_text(val)
{
    h = Math.floor(val/60);
    m = val%60;

    return `${h}:${m}`;
}
function dur_to_time(dur)
{
    let res = 60*dur.hours+dur.minutes
    return res;
}