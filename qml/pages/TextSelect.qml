import QtQuick 2.0
import Sailfish.Silica 1.0

import "../tdt/todotxt.js" as JS


Page {
    id: page
    state: "priorities"

    SilicaListView {
        id: lv
        anchors.fill: parent

        VerticalScrollDecorator {}
        property string title: ""
        header: PageHeader {
            title: lv.title
        }

        ViewPlaceholder {
            enabled: lv.count === 0
            id: vp
            text: qsTr("No entries")
        }

        delegate: ListItem {
            Label {
                id: lbl;
                x: Theme.horizontalPageMargin
                text: model.name
            }
            onClicked: setString(lbl.text)
        }
    }

    ListModel {
        id: prioritiesModel
        Component.onCompleted: {
            for (var a in JS.alphabet) {
                append({"name": "(" + JS.alphabet[a] + ") "});
            }
        }
    }

    function setString(txt) {
        pageStack.previousPage().setText(state, txt)
        pageStack.pop()
    }

    states: [
        State {
            name: "priorities"
            PropertyChanges {
                target: lv
                model: prioritiesModel
                title: qsTr("Priorities")
            }
        },
        State {
            name: "projects"
            PropertyChanges {
                target: lv;
                model: ttm1.filters.projectsModel
                title: qsTr("Projects")
            }
        },
        State {
            name: "contexts"
            PropertyChanges {
                target: lv;
                model: ttm1.filters.contextsModel
                title: qsTr("Contexts")
            }
        }
    ]
}

