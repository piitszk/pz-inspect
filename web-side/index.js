const Sensitivity = 0.1
let Rotation = { x: 0.0, y: -0.0 }
let SaveRotation = { x: 0.0, y: -0.0 }

const mouseMoveHandler = ({ pageX: mouseX, pageY: mouseY }) => {
    const deltaX = (mouseX - SaveRotation["x"]) * Sensitivity
    const deltaY = (mouseY - SaveRotation["y"]) * Sensitivity
    
    Rotation["x"] += deltaX + 0.001
    Rotation["y"] += deltaY + 0.001

    SaveRotation["x"] = mouseX + 0.001
    SaveRotation["y"] = mouseY + 0.001

    $.post(`https://${GetParentResourceName()}/Rotate`, JSON.stringify({
        x: Rotation["x"],
        y: Rotation["y"]
    }))
}

$(() => {
    $("body").css({
        "display": "flex",
        "justify-content": "center",
        "align-items": "center",
        "height": "100vh",
        "overflow": "hidden"
    })

    $("#detection-area").css({
        "width": "1000px",
        "height": "600px"
    })

    $("#detection-area").on("mousedown", function() {
        SaveRotation["x"] = event["pageX"]
        SaveRotation["y"] = event["pageY"]

        $(document).on("mousemove", mouseMoveHandler)
    })

    $(document).on("mouseup", function() {
        $(document).off("mousemove")
    })

    $(document).keyup(function(Data) {
        if (Data["key"] === "Escape") {
           $.post(`https://${GetParentResourceName()}/CloseInspect`)
       }
   })

    window.addEventListener("message", (event) => {
        const Data = event["data"]

        if (Data["Action"] == "Reset") {
            Rotation = { x: Data["Heading"], y: 0.0 }
            SaveRotation = { x: Data["Heading"], y: 0.0 }
        }
    })
})
