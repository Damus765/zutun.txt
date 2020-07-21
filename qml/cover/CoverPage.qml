import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components"
import "../tdt"

CoverBackground {
    id: cb
    Image {
        source: "coversmall.png"
        anchors.centerIn: parent
        opacity: 0.2
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
    }

    SilicaListView {
        anchors.fill: parent
        anchors.margins: Theme.paddingMedium
        clip: true
        //TODO use package??
        model: taskListModel
        delegate: CoverListItem { }
    }

    CoverActionList {
        CoverAction {
            iconSource: "image://theme/icon-cover-new"
            onTriggered: {
                app.addTask();
            }
        }
    }
}


