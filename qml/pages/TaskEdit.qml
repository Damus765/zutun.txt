import QtQuick 2.0
import Sailfish.Silica 1.0


//TODO project/context einfügen
//TODO prio: erkennen wo eingesetzt bzw ersetzt werden soll
//TODO enter key entfernen

Dialog {
    id: dialog
    //    acceptDestination: page
    acceptDestinationAction: PageStackAction.Pop

    property int itemIndex
    property string text
    property string selectedPriority
    onSelectedPriorityChanged: ta.text = selectedPriority + ta.text


    Column {
        anchors.fill: parent
        DialogHeader {
            title: "Edit Task"
        }
        TextArea {
            id: ta
            width: dialog.width
            text: dialog.text
        }
        Row {
            x: Theme.horizontalPageMargin
            spacing: Theme.paddingSmall
            IconButton {
                icon.source: "image://theme/icon-l-date"
                onClicked: {
                    ta.text = tdt.today() + " " + ta.text;
                    ta.focus = true; //soll eigentl das keyboard wieder aktivieren, geht aber nicht immer.
                }
            }
            Button {
                height: parent.height
                width: height
                text: "(A)"
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("TextSelect.qml", {state: "priorities"}))
                }
            }
            Button {
                height: parent.height
                width: height
                text: "@"
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("ProjectFilter.qml"))
                }
            }
            Button {
                height: parent.height
                width: height
                text: "+"
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("ProjectFilter.qml"))
                }
            }
        }
    }

    onAccepted: {
        ta.focus = false; //damit das Keyboard einklappt
        tdt.setFullText(itemIndex, ta.text);
        pageStack.navigateBack();
    }
    onCanceled: {
        ta.focus = false; //damit das Keyboard einklappt
        pageStack.navigateBack();
    }
}
