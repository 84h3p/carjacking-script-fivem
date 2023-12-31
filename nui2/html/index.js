$(function () {
    function display(bool) {
        if (bool) {
            $("#container").show();
            document.getElementById('result').innerHTML = ''
            const lockElement = document.querySelector(".lock");
            const pickElement = document.querySelector(".pick");
            const resultElement = document.getElementById("result");
  
            let isPicking = false;
            let unlocked = false;
            let targetX = 0;
            let targetY = 0;
  
            lockElement.addEventListener("mousedown", function () {
              isPicking = true;
            });
  
            document.addEventListener("mouseup", function () {
              isPicking = false;
              if (unlocked) {
                resultElement.textContent = "Замок открыт!";
                $.post('http://carjacking-script-fivem/open', JSON.stringify({}));
                return;
              } else {
                resultElement.textContent = "Отмычка вернулась назад.";
                resetPickPosition();
              }
            });
  
            lockElement.addEventListener("mousemove", function (event) {
              if (isPicking) {
                const lockRect = lockElement.getBoundingClientRect();
                const mouseX = event.clientX - lockRect.left;
                const mouseY = event.clientY - lockRect.top;
  
                if (mouseX >= 0 && mouseX <= lockRect.width - 50) {
                  pickElement.style.left = mouseX + "px";
                }
  
                if (mouseY >= 0 && mouseY <= lockRect.height - 20) {
                  pickElement.style.top = mouseY + "px";
                }
  
                // Checking is lockpick in the right zone
                const zoneWidth = 10; // Width of the zone
  
                if (mouseX >= targetX && mouseX <= targetX + zoneWidth && mouseY <= targetY) {
                  unlocked = true;
                  pickElement.classList.add("in-zone"); // Adding green color
                } else {
                  unlocked = false;
                  pickElement.classList.remove("in-zone"); // Remove green color
                }
              }
            });
  
            function resetPickPosition() {
              const lockRect = lockElement.getBoundingClientRect();
              targetX = Math.floor(Math.random() * (lockRect.width - 50));
              targetY = Math.floor(Math.random() * (lockRect.height - 20));
              pickElement.style.left = "80px";
              pickElement.style.top = "40px";
              unlocked = false;
              pickElement.classList.remove("in-zone"); // Remove color when reset the lockpick
            }
  
            // Инициализация начального положения отмычки
            resetPickPosition();
        } else {
            $("#container").hide();
        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }
        }
    })
    // if the person uses the escape key, it will exit the resource
    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('http://carjacking-script-fivem/exit', JSON.stringify({}));
            return
        }
    };
    //when the user clicks on the submit button, it will run
    $("#submit").click(function () {
        let inputValue = $("#input").val()
        if (inputValue.length >= 100) {
            $.post("http://carjacking/error", JSON.stringify({
                error: "Input was greater than 100"
            }))
            return
        } else if (!inputValue) {
            $.post("http://carjacking/error", JSON.stringify({
                error: "There was no value in the input field"
            }))
            return
        }
        // if there are no errors from above, we can send the data back to the original callback and hanndle it from there
        $.post('http://carjacking/main', JSON.stringify({
            text: inputValue,
        }));
        return;
    })
})
