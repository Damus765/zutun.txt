import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Context Filters")
                onClicked: pageStack.pop();
            }
            MenuItem {
                text: qsTr("Project Filters")
                onClicked: pageStack.pop();
            }
            MenuItem {
                text: qsTr("Back To Tasklist")
                onClicked: {
                    pageStack.pop(pageStack.find(function(p){ return (p._depth === 0)}))
                }
            }
        }

        contentHeight: column.height + Theme.paddingLarge


        Column {
            id: column
            width: parent.width
            PageHeader {
                title: qsTr("Other Filters");
            }

            TextSwitch {
                x: Theme.horizontalPageMargin
                text: "Hide Completed Tasks"
                checked: tdt.filterDone
                onClicked: tdt.filterDone = checked
            }
        }
    }

    onStatusChanged: {
        //        if (status === PageStatus.Active /*&& pageStack.depth === 1 */) {
        //            pageStack.pushAttached("OtherFilters.qml", {});
        //        }
    }
}
