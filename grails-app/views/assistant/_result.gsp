
    <g:if test="${user.size() > 0}">
        <h6>${user.size()} Treffer</h6>
        <ul class="mdl-list">
            <g:each in="${user}">
                <li class="mdl-list__item mdl-list__item--two-line">
                    <span class="mdl-list__item-primary-content">
                        <i class="material-icons mdl-list__item-avatar">person</i>
                        <span>${it.name}</span>
                        <span class="mdl-list__item-sub-title">User Id: ${it.id}</span>
                    </span>

                    <span class="mdl-list__item-secondary-content">
                        <span class="mdl-list__item-secondary-info">add</span>
                        <a class="mdl-list__item-secondary-action" href="${createLink(controller: 'assistant', action: 'add', id: it.id)}"><i class="material-icons">add</i></a>
                    </span>
                </li>
            </g:each>

        </ul>
    </g:if>
    <g:else>
        Keine Ergebnisse
    </g:else>

%{--<div>--}%
    %{--<g:if test="${user.size()>0}">--}%
        %{--<table class="striped appointment-table">--}%
            %{--<thead>--}%
                %{--<tr>--}%
                    %{--<th>Name</th>--}%
                    %{--<th>User ID</th>--}%
                    %{--<th>Eintragen</th>--}%
                %{--</tr>--}%
            %{--</thead>--}%
            %{--<tbody>--}%
            %{--<g:each in="${user}">--}%
                %{--<tr>--}%
                    %{--<td>--}%
                        %{--${it.name}--}%
                    %{--</td>--}%
                    %{--<td>--}%
                        %{--${it.id}--}%
                    %{--</td>--}%
                    %{--<td>--}%
                        %{--<a href="${createLink(controller: 'assistant', action: 'add', id: it.id)}" >Als Assistent hinzufügen</a>--}%
                    %{--</td>--}%
                %{--</tr>--}%
            %{--</g:each>--}%
            %{--</tbody>--}%
        %{--</table>--}%
    %{--</g:if>--}%
    %{--<g:else>--}%
        %{--Kein Ergebnis--}%
    %{--</g:else>--}%
%{--</div>--}%