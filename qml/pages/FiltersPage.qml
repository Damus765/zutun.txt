import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page
    property bool skip: false
    state: "projects"

    SilicaListView {
        id: lv
        property string btnTxt: "Clear Project Filter"
        property string title: "Projects"

        anchors.fill: parent

        PullDownMenu {
            enabled: lv.count > 0
            MenuItem {
                text: lv.btnTxt
                onClicked: { taskModel.filters.clearFilter(page.state); }
            }
        }

        VerticalScrollDecorator {}

        header: PageHeader {
            title: lv.title
            description: qsTr("Active Filters: %1").arg(filters.text())
        }

        ViewPlaceholder {
            enabled: lv.count == 0
            text: qsTr("No entries")
        }

        delegate: ListItem {
            enabled: model.visibleItemCount > 0
            highlighted: model.active
            onClicked: filters.setByName(model.name, !model.active);
            Label {
                //                        id: lbl
                color: (model.visibleItemCount > 0? Theme.primaryColor : Theme.secondaryColor)
                anchors.verticalCenter: parent.verticalCenter
                x: Theme.horizontalPageMargin
                text: model.name + " (" + model.visibleItemCount + "/" + model.itemCount + ")"
            }
        }
    }
    onStatusChanged: {
        if (status === PageStatus.Active) {
            if ( pageStack.depth === 1) {
                if (settings.projectFilterLeft) {
                    pageStack.pushAttached(Qt.resolvedUrl("TaskList.qml"), {});
                    if (skip) {
                        pageStack.navigateForward(PageStackAction.Immediate)
                        skip = false
                    }
                } else {
                    pageStack.replace(Qt.resolvedUrl("TaskList.qml"), {}, PageStackAction.Immediate);
                }
            } else {
                if (state == "contexts") { pageStack.pushAttached("OtherFilters.qml");}
                if (state == "projects") pageStack.pushAttached("FiltersPage.qml", {state: "contexts"});
            }
        }
    }

    states: [
        State {
            name: "projects"
            PropertyChanges {
                target: lv;
                title: qsTr("Filter Projects")
                model: filters.projects.list
                btnTxt: qsTr("Clear Project Filters")
            }
        }
        , State {
            name: "contexts"
            PropertyChanges {
                target: lv;
                title: qsTr("Filter Contexts")
                model: filters.contexts.list
                btnTxt: qsTr("Clear Context Filters")
            }
        }

    ]
}
