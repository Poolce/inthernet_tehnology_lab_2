$(document).ready(async function()
{
    let tags = await $.post('http://localhost:8000/get_tags',{});
    for(i=0;i<tags.length;i++)
    {
        $el = document.createElement('option');
        $el.textContent = tags[i].name;
        document.getElementById('selectvalue').appendChild($el);
    }
    document.getElementById('date').setAttribute('min',new Date(new Date().getTime()+(24 * 60 * 60 * 1000)).toISOString().split("T")[0]);
    $('#selectvalue').change();
});