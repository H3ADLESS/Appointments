<%@ page import="appointments.Department; appointments.Lecturer" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="mdl-main-layout"/>
    <g:set var="entityName" value="${message(code: 'officeHour.label', default: 'Office Hour')}"/>
    <title>${entityName} - Einstellungen</title>
</head>

<body>

<div class="mdl-grid">

    <div class="mdl-cell mdl-cell--12-col">
        <h4><g:message code="userSettings.assistant"/></h4>
        <p>Hier können Sie einem Assistenten Zugriff auf Ihre Sprechstunden gewähren. Dieser kann dann Sprechstunden und Termine für Sie verwalten. Sie können nur angemeldete Benutzer hinzufügen.</p>

        <g:if test="${flash.message}">
            <div class="chip" style="width: 100%; height: auto; padding: 0.4em 2em;">
                ${flash.message}
                <i class="close material-icons">close</i>
            </div>
        </g:if>
    </div>

    <div class="mdl-cell mdl-cell--12-col">
        <h5>Nutzer suchen:</h5>
        <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
            <input class="mdl-textfield__input" type="text" id="name" name="name">
            <label class="mdl-textfield__label" for="name">Name</label>
        </div>
    </div>

    <div class="mdl-cell mdl-cell--12-col">
        <b>Suchergebnisse:</b>
        <div id="resultSet" style="margin-top: 1em;">

        </div>
    </div>

    <div class="mdl-cell mdl-cell--12-col">
        <div class="col s12">
            <h5>Eingetragene Assistenten</h5>

            <ul class="mdl-list">
                <g:each in="${assistants}">
                    <li class="mdl-list__item mdl-list__item--two-line">
                        <span class="mdl-list__item-primary-content">
                            <i class="material-icons mdl-list__item-avatar">person</i>
                            <span>${it.firstName} ${it.lastName}</span>
                            <span class="mdl-list__item-sub-title">User Id: ${it.id}</span>
                        </span>

                        <span class="mdl-list__item-secondary-content">
                            <span class="mdl-list__item-secondary-info">remove</span>
                            <a class="mdl-list__item-secondary-action" href="${createLink(controller: 'assistant', action: 'remove', id: it.id)}"><i class="material-icons">remove</i></a>
                        </span>
                    </li>
                </g:each>

            </ul>

            %{--<table class="striped appointment-table">--}%
                %{--<thead>--}%
                    %{--<tr>--}%
                        %{--<th>Name</th>--}%
                        %{--<th>User ID</th>--}%
                        %{--<th></th>--}%
                    %{--</tr>--}%
                %{--</thead>--}%
                %{--<tbody>--}%
                    %{--<g:each in="${assistants}">--}%
                        %{--<tr>--}%
                            %{--<td>--}%
                                %{--${it.firstName} ${it.lastName}--}%
                            %{--</td>--}%
                            %{--<td>--}%
                                %{--${it.id}--}%
                            %{--</td>--}%
                            %{--<td>--}%
                                %{--<a href="${createLink(controller: 'assistant', action: 'remove', id: it.id)}" >Assistent entfernen</a>--}%
                            %{--</td>--}%
                        %{--</tr>--}%
                    %{--</g:each>--}%
                %{--</tbody>--}%
            %{--</table>--}%

        </div>
    </div>
</div>


<script>
    $(document).ready(function () {
        updateList();
        $("#name").on('input', updateList);
    });

    function updateList() {
        var name = $("#name").val();

        $.ajax({
            url: "${createLink (controller:"assistant", action:"search")}",
            data: {
                name: name
            }
        }).done( function(data) {
            console.log(data);
            $("#resultSet").html(data);
        });
    }
</script>

</body>

