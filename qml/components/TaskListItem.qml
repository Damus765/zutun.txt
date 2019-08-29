import QtQuick 2.6
import Sailfish.Silica 1.0
import Sailfish.Silica.private 1.0

import "../tdt/todotxt.js" as JS

ListItem {
    id: listItem

    property alias done: doneSw.checked
    property string priority: ""
    property alias subject: parser.text
    property alias creationDate: cdLbl.text
    property alias due: dueLbl.text

    signal toggleDone()
    signal editItem()
    signal removeItem()
    signal prioUp()
    signal prioDown()

    function remove() {
        remorseAction("Deleting", function() {
            animateRemoval()
            removeItem()
        })
    }
    onClicked: editItem()
    contentHeight: col.height + lv.spacing

    Column {
        id: col
        width: page.width
        anchors.verticalCenter: parent.verticalCenter
        Row {
            id: row
            //            x: Theme.horizontalPageMargin
            Switch {
                id: doneSw
                height: lbl.height
                automaticCheck: false
                checked: listItem.done
                onClicked: toggleDone()
            }

            Label {
                id:lbl

                width: listItem.width - doneSw.width - 2*Theme.horizontalPageMargin
                linkColor: Theme.primaryColor
                text: formatText(parser.linkedText)
                textFormat: Text.StyledText
                wrapMode: Text.Wrap
                font.strikeout: listItem.done
                font.pixelSize: settings.fontSizeTaskList

                onLinkActivated: {
                    //if (defaultLinkActions) {
                    Qt.openUrlExternally(link)
                    //}
                }

                function prioColor(p) {
                    console.log(Theme.colorScheme)
                    return "red"
                }

                function formatText(txt) {
                    txt = txt.replace(/\n/g, '<br>')
                    txt = (priority !== "" ?
                                           '<font color="' + prioColor(priority)
                                           + '">(' + priority + ') </font>' : "")
                            + txt

                    txt = txt.replace(JS.projects.pattern,
                                      function(x) { return ' <font color="' + Theme.highlightColor + '">' + x + ' </font>'})
                    return txt.replace(JS.contexts.pattern,
                                       function(x) { return ' <font color="' + Theme.secondaryHighlightColor + '">' + x + ' </font>'})
                }

                LinkParser {
                    id: parser
                }
            }
        }
        Row {
            //                            x: Theme.horizontalPageMargin
            spacing: Theme.paddingSmall
            anchors.right: parent.right
            anchors.rightMargin: Theme.horizontalPageMargin
            property int fontSize: Theme.fontSizeExtraSmall

            Label {
                visible: creationDate !== "";
                text: qsTr("created:");
                font.pixelSize: parent.fontSize
                //font.bold: true;
                color: Theme.highlightColor
            }
            Label {
                id: cdLbl
                visible: creationDate !== "";
                font.pixelSize: parent.fontSize
            }
            Label {
                visible: due !== "";
                text: qsTr("due:");
                font.pixelSize: parent.fontSize
                color: Theme.highlightColor
            }
            Label {
                id: dueLbl
                visible: due !== ""
                font.pixelSize: parent.fontSize
            }
        }
    }

    menu: ContextMenu {
        //                    DetailItem { visible: model.creationDate !== ""; label: qsTr("Creation Date"); value: model.creationDate }
        MenuItem {
            visible: !(done || priority === "A")
            text: qsTr("Priority Up")
            onClicked: prioUp()
        }
        MenuItem {
            visible: !(done || priority === "")
            text: qsTr("Priority Down")
            onClicked: prioDown()
        }
        MenuItem {
            text: qsTr("Remove")
            onClicked: remove()
        }
    }
}