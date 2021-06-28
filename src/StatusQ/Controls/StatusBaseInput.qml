import QtQuick 2.14

import QtQuick.Controls 2.14 as QC

import StatusQ.Controls 0.1
import StatusQ.Core 0.1
import StatusQ.Core.Theme 0.1


Item {
    id: statusBaseInput

    property bool multiline: false

    property bool clearable: false

    property alias inputMethodHints: edit.inputMethodHints

    property alias selectedText: edit.selectedText
    property alias selectedTextColor: edit.selectedTextColor
    property alias selectionStart: edit.selectionStart
    property alias selectionEnd: edit.selectionEnd

    property alias color: edit.color
    property alias font: edit.font
    property alias verticalAlignmet: edit.verticalAlignment
    property alias horizontalAlignment: edit.horizontalAlignment

    property alias placeholderText: placeholder.text
    property alias placeholderTextColor: placeholder.color
    property alias placeholderFont: placeholder.font

    property real leftPadding: 16
    property real rightPadding: 16
    property real topPadding: 11
    property real bottomPadding: 11

    property real minimumHeight: 0
    property real maximumHeight: 0

    implicitWidth: 200
    implicitHeight: multiline ? Math.max(edit.implicitHeight + topPadding + bottomPadding, 40) : 40

    Rectangle {
        width: parent.width
        height: maximumHeight != 0 ? Math.min(
                                        minimumHeight != 0 ? Math.max(statusBaseInput.implicitHeight, minimumHeight)
                                                          : implicitHeight,
                                         maximumHeight)
                                  : parent.height
        color: Theme.palette.baseColor2
        radius: 8

        clip: true

        Flickable {
            id: flick

            anchors.fill: parent
            anchors.leftMargin: statusBaseInput.leftPadding
            anchors.rightMargin: statusBaseInput.rightPadding + clearable ? clearButtton.width : 0
            anchors.topMargin: statusBaseInput.topPadding
            anchors.bottomMargin: statusBaseInput.bottomPadding
            contentWidth: edit.paintedWidth
            contentHeight: edit.paintedHeight
            clip: true

            QC.ScrollBar.vertical: QC.ScrollBar { interactive: multiline }


            function ensureVisible(r) {
                if (contentX >= r.x)
                    contentX = r.x;
                else if (contentX+width <= r.x+r.width)
                    contentX = r.x+r.width-width;
                if (contentY >= r.y)
                    contentY = r.y;
                else if (contentY+height <= r.y+r.height)
                    contentY = r.y+r.height-height;
            }



            TextEdit {
                id: edit
                width: flick.width
                selectByMouse: true
                anchors.verticalCenter: parent.verticalCenter
                focus: true

                font.pixelSize: 15
                font.family: Theme.palette.baseFont.name
                color: Theme.palette.directColor1

                onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
                wrapMode: TextEdit.NoWrap

                Keys.onReturnPressed: {
                    if (multiline) {
                        event.accepted = false
                    } else {
                        event.accepted = true
                    }
                }

                Keys.onEnterPressed: {
                    if (multiline) {
                        event.accepted = false
                    } else {
                        event.accepted = true
                    }
                }

                StatusBaseText {
                    id: placeholder
                    visible: edit.text.length === 0
                    anchors.left: parent.left
                    anchors.right: parent.right
                    font.pixelSize: 15

                    elide: StatusBaseText.ElideRight
                    font.family: Theme.palette.baseFont.name
                    color: Theme.palette.baseColor1
                }
            }
        } // Flickable
    } // Rectangle

    StatusFlatRoundButton {
        id: clearButtton
        visible: edit.text.length != 0 && statusBaseInput.clearable && !statusBaseInput.multiline
        anchors.right: parent.right
        anchors.rightMargin: 11
        anchors.verticalCenter: parent.verticalCenter
        type: StatusFlatRoundButton.Type.Secondary
        width: 14
        height: 14
        icon.name: "clear"
        icon.width: 14
        icon.height: 14
        onClicked: {
            edit.clear()
        }
    }

}