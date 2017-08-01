<%@ page import="appointments.Department" %>
<!doctype html>
<html lang="en" class="no-js">
<head>
    <meta name="layout" content="mdl-main-layout"/>
</head>
<body>

    <g:ifTutorialEnabled>
        <g:render template="firstVisit"/>
    </g:ifTutorialEnabled>

    <div class="mdl-grid">

        <div class="mdl-cell mdl-cell--12-col">
            <div class="stepper">
                <div class="step active">
                    <div class="stepper-cirlce">
                        <div style="margin: auto">1</div>
                    </div>
                    <div class="stepper-text">
                        Dozent auswählen
                    </div>
                </div>

                <div class="spacer"></div>

                <div class="step">
                    <div class="stepper-cirlce">
                        <div style="margin: auto">2</div>
                    </div>
                    <div class="stepper-text">
                        Termin wählen
                    </div>
                </div>

                <div class="spacer"></div>

                <div class="step">
                    <div class="stepper-cirlce">
                        <div style="margin: auto">3</div>
                    </div>
                    <div class="stepper-text">
                        Eckdaten mitteilen
                    </div>
                </div>

            </div>
        </div>

        <div class="mdl-cell mdl-cell--12-col">
            <h4>Termin vereinbaren</h4>
            <h6>Wählen Sie einen Dozenten um verfügbare Termine anzuzeigen und einen Termin zu vereinbaren.</h6>
        </div>

        <div class="mdl-cell mdl-cell--12-col">
            <div style="margin-right: 1em; float: left">
                <div class="mdl-textfield mdl-js-textfield">
                    <input class="mdl-textfield__input" type="text" id="lecturer-input">
                    <label class="mdl-textfield__label" for="lecturer-input">Nach Name suchen</label>
                </div>
                <i class="material-icons">search</i>
            </div>

            <div class="dropdown-textfield">
                <div id="filter-input" class="dropdown" type="text">
                    <span class="dropdown-text">Fachbereich</span>
                    <div style="float: right">
                        <i style="color: black" class="material-icons">arrow_drop_down</i>
                    </div>
                    <ul class="dropdown-options-container">
                        <li class="dropdown-option" data-id="0">Nicht filtern</li>
                        <g:each in="${Department.findAll()}">
                            <li class="dropdown-option" data-id="${it.id}">${it.name}</li>
                        </g:each>
                    </ul>
                </div>
            </div>

            <script>
                $(document).ready(function () {
                    (function () {
                        var filterInput = $("#filter-input");
                        var dropdownText = filterInput.children(".dropdown-text");
                        var optionContainer = filterInput.children(".dropdown-options-container");
                        var options = optionContainer.children(".dropdown-option");

                        filterInput.on('click', function (event) {
                            optionContainer.slideToggle();
                            event.stopPropagation();
                        });

                        $('html').on("click", function () {
                            if (optionContainer.is(":visible")){
                                optionContainer.slideToggle();
                            }
                        });

                        options.on('click', function () {
                            var text = $(this).text();
                            var id = $(this).data("id");
                            if (id !== 0){
                                dropdownText.text(text);
                                dropdownText.css("color", "black");
                                options.removeClass("selected");
                                $(this).addClass("selected");
                                updateList();
                            } else {
                                options.removeClass("selected");
                                $(this).addClass("selected");
                                dropdownText.text(text);
                                dropdownText.css("color", "");
                                updateList();
                            }
                        })
                    })();
                })
            </script>
        </div>
    </div>

    <hr>

    <div id="spinner" style="margin: 5em calc(50% - 25px); display: none">
        <div class="mdl-spinner mdl-spinner--single-color mdl-js-spinner is-active"></div>
    </div>

    <div id="resultset" class="mdl-grid section--center" style="margin-bottom: 2em;">

    </div>



    <script>
        $(document).ready(function() {
            %{--<sec:ifLoggedIn>--}%
            %{--$(".button-collapse").sideNav();--}%
            %{--</sec:ifLoggedIn>--}%

            %{--$(document).ready(function() {--}%
            %{--$('select').material_select();--}%
            %{--});--}%

            updateList();

            var lecturerInput = $("#lecturer-input");
            $("#lecturer-input").on('input', updateList);
            $("#department-id").on('change', updateList);

        });

        function updateList() {
            var lecturerName = $("#lecturer-input").val();
//                var departmentId = $("#department-id").val();

            var departmentId = 0;
            var filterOptions = $("#filter-input").children(".dropdown-options-container").children(".dropdown-option");
            var selectedOption = filterOptions.filter(".selected");
            if (selectedOption !== undefined) {
                departmentId = selectedOption.data("id");
            }

            console.log(departmentId);

            $("#spinner").show();
            $("#resultset").hide();

            $.ajax({
                url: "${createLink (controller:"home", action:"search")}",
                data: {
                    name: lecturerName,
                    departmentId: departmentId
                }
            }).done( function(data) {
                $("#resultset").html(data);
                $("#spinner").hide();
                $("#resultset").show();
            });
        }
    </script>

</body>

</html>