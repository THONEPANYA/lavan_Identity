$(function() {
    window.addEventListener('message', function(event) {
        let item = event.data;

        if (item.type === "enableui") {
            if (item.enable) {
                $('#ui-container').removeClass('hidden');

                if (item.data) {
                    $('#avatar').attr('src', item.data.avatarUrl);
                    $('#discord-name').text(item.data.discord_name);
                    
                    $('#firstname').val(item.data.firstname);
                    $('#lastname').val(item.data.lastname);
                    
                    // ดึงแค่วันที่ (ตัดเวลาออกถ้าฐานข้อมูลส่งเวลามาด้วย)
                    let cleanDob = item.data.dob.split('T')[0]; 
                    $('#dob').val(cleanDob);
                    
                    $('#height').val(item.data.height);
                    
                    let genderVal = item.data.gender;
                    let displayGender = "ไม่ระบุ";
                    if (genderVal === "m") displayGender = "ชาย (Male)";
                    if (genderVal === "f") displayGender = "หญิง (Female)";
                    if (genderVal === "lg") { displayGender = "LGBTQ+"; genderVal = "m"; }
                    
                    $('#gender-display').val(displayGender);
                    $('#gender').val(genderVal);
                }
            } else {
                $('#ui-container').addClass('hidden');
            }
        }
    });

    $('#identity-form').submit(function(e) {
        e.preventDefault();

        let data = {
            firstname: $('#firstname').val(),
            lastname: $('#lastname').val(),
            dob: $('#dob').val(),
            height: $('#height').val(),
            gender: $('#gender').val()
        };

        $('#submit-btn').prop('disabled', true).text('กำลังสร้างตัวละคร...');
        
        // จุดนี้ชื่อ url ต้องตรงกับชื่อโฟลเดอร์สคิปต์
        $.post('https://lavan_identity/register', JSON.stringify(data));
    });
});