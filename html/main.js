$(function(){
    window.addEventListener("message", function(event){
        if (event.data.pauseMenu == false && event.data.hideHUD == false) {
            var selector = document.querySelector("#bars")
            selector.style = "opacity:1.0;";

            document.getElementById("idbar").innerHTML = event.data.id;

            if (event.data.armour <=0 ){
                $('#stt-armour').fadeOut();
            } else {
                $('#stt-armour').fadeIn();
            }

            if (event.data.inVehicle == false){

                if (event.data.isPedRun == false && event.data.IsPedSwin == false){
                    document.querySelector("#stt-stamina").style = "opacity:0.0;";
                } else if (event.data.isPedRun == true) {
                    document.getElementById("stt-stamina").innerHTML = '<img src="img/flash.png" class="center">' +
                    '<div class="staminabar"><div class="bar-stamina"></div></div>';
                    document.querySelector("#stt-stamina").style = "opacity:1.0;";
                }else if (event.data.IsPedSwin == true) {
                    document.getElementById("stt-stamina").innerHTML = '<img src="img/o2.png" class="center">' +
                    '<div class="staminabar"><div class="bar-oxygen"></div></div>';
                    document.querySelector("#stt-stamina").style = "opacity:1.0;";
                }

                $('#status').css({'left': 310 + 'px'});
                $('#status').css({'bottom': 35 + 'px'});


                document.querySelector("#carhud").style = "opacity:0.0;";

            } else {

                $('#status').css({'left': 310 + 'px'});
                $('#status').css({'bottom': 35 + 'px'});


                if (event.data.isCar){
                    $('#belt').fadeIn();
                } else {
                    $('#belt').fadeOut();
                }

                if (event.data.isBike){
                    $('#dashboard').fadeOut();
                    $('#board-gear').fadeOut();
                } else {
                    $('#dashboard').fadeIn();
                    $('#board-gear').fadeIn();
                }


                document.getElementById("gear").innerHTML = event.data.gear;
                document.getElementById("fuel").innerHTML = event.data.fuel;
                document.getElementById("speedtxt").innerHTML = "<span style='font-size:15px'>  KMH  </span>"+"<span style='font-size:30px'>"+event.data.kmh+"</span>";
                document.querySelector("#carhud").style = "opacity:1.0;";

                if (event.data.belt){
                    document.getElementById("belt").innerHTML = '<img src="img/belt-on.png" style="width: 20px;">';
                } else {
                    document.getElementById("belt").innerHTML = '<img src="img/belt-off.png" style="width: 20px;">';
                }

                if (event.data.enginerunning){
                    document.getElementById("enginerunning").innerHTML = '<img src="img/vehicle-on.png" style="width: 20px;">';
                } else {
                    document.getElementById("enginerunning").innerHTML = '<img src="img/vehicle-off.png" style="width: 20px;">';
                }

                if (event.data.kmh <= 250){
                    $('.bar-speed').css({
                        'width': ((event.data.kmh / 250) * 100) + '%'
                    });
                } else {
                    $('.bar-speed').css({
                        'width': 100 + '%'
                    });
                }
                
            }


            $('.bar-health').css({
                'width': event.data.health + '%'
            });

            $('.bar-armour').css({
                'width': event.data.armour + '%'
            });

            $('.bar-food').css({
                'width': event.data.food + '%'
            });

            $('.bar-water').css({
                'width': event.data.water + '%'
            });

            $('.bar-stamina').css({
                'width': event.data.stamina + '%'
            });

            $('.bar-oxygen').css({
                'width': event.data.oxygen + '%'
            });


       } else {
            var selector = document.querySelector("#bars")
            selector.style = "opacity:0.0;"
        }
    })
})