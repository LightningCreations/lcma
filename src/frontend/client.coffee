
# Hides all sections except X
handleSections = (sections, x) ->
    sectionNumbers = 0
    while sectionNumbers < sections.length
        sections[sectionNumbers].style.display = ""

        sectionNumbers++

    sectionNumbers = 0
    while sectionNumbers < sections.length
        if sectionNumbers != x
            sections[sectionNumbers].style.display = "none"

        sectionNumbers++

# Counts the number of sections on the form
countSections = (sections) ->
    sectionNumbers = 0
    while sectionNumbers < sections.length
        sectionNumbers++
    return sectionNumbers - 1

# Switch Button Shown
switchToNextBtn = () ->
    nextBtn = document.getElementById "next"
    submitBtn = document.getElementById "submit"
    nextBtn.style.display = ""    # Show Next Button
    submit.style.display = "none" # Hide Submit Button

switchToSubmitBtn = () ->
    nextBtn = document.getElementById "next"
    submitBtn = document.getElementById "submit"
    nextBtn.style.display = "none"# Hide Next Button
    submit.style.display = ""     # Show Submit Button

# Validates a section
validateFormSection = (section) ->
    inputs = document.querySelector(".section-" + section).getElementsByTagName("input")

    console.info inputs

    isValid = false

    inputNumbers = 0
    while inputNumbers < inputs.length
        if inputs[inputNumbers].type == "text"
            if inputs[inputNumbers].value.length != 0
                isValid = true

        if inputs[inputNumbers].type == "email"
            if inputs[inputNumbers].checkValidity()
                isValid = true

        if inputs[inputNumbers].type == "radio"
            if inputs[inputNumbers].checked == true
                isValid = true

        inputNumbers++

    return isValid

window.addEventListener 'load', ->
    activeSection = 0 # Start at beggining

    switchToNextBtn()

    backBtn = document.getElementById "back"
    nextBtn = document.getElementById "next"
    sections = document.getElementsByClassName "section"

    backBtn.style.display = ""

    sectionCount = countSections sections

    nextBtn.onclick = ->
        isValid = validateFormSection(activeSection)

        if !isValid
            alert("Please fill out all entries on the form.")

        if activeSection != sectionCount && isValid
            activeSection += 1
        if activeSection == sectionCount
            switchToSubmitBtn()

        handleSections(sections, activeSection)


    backBtn.onclick = ->
        if activeSection > 0
            activeSection -= 1
            switchToNextBtn()

        handleSections(sections, activeSection)


    handleSections(sections, activeSection)

    (section) ->
        console.info "ok"
        section.style.display = "none"
