import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtGraphicalEffects 1.13

import StatusQ.Core 0.1
import StatusQ.Core.Theme 0.1
import StatusQ.Popups 0.1

Item {
    enum MenuAlignment {
        Left,
        Right,
        Center
    }
    property string label: ""
    readonly property bool hasLabel: label !== ""
    property color bgColor: Theme.palette.baseColor2
    readonly property int labelMargin: Theme.dp(7)
    property var model
    property alias selectMenu: selectMenu
    property color bgColorHover: bgColor
    property alias selectedItemComponent: selectedItemContainer.children
    property int caretRightMargin: Theme.dp(16)
    property alias select: inputRectangle
    property int menuAlignment: StatusSelect.MenuAlignment.Right
    property Item zeroItemsView: Item {}
    property string validationError: ""
    property alias validationErrorAlignment: validationErrorText.horizontalAlignment
    property int validationErrorTopMargin: Theme.dp(11)
    implicitWidth: Theme.dp(448)

    id: root
    height: inputRectangle.height + (hasLabel ? inputLabel.height + labelMargin : 0) + (!!validationError ? (validationErrorText.height + validationErrorTopMargin) : 0)

    StatusBaseText {
        id: inputLabel
        visible: hasLabel
        text: root.label
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        font.pixelSize: Theme.dp(15)
        color: root.enabled ? Theme.palette.directColor1 : Theme.palette.baseColor1
    }

    Rectangle {
        property bool hovered: false
        id: inputRectangle
        height: Theme.dp(56)
        color: hovered ? bgColorHover : bgColor
        radius: Theme.dp(8)
        anchors.top: root.hasLabel ? inputLabel.bottom : parent.top
        anchors.topMargin: root.hasLabel ? root.labelMargin : 0
        anchors.right: parent.right
        anchors.left: parent.left
        border.width: !!validationError ? Theme.dp(1) : 0
        border.color: Theme.palette.dangerColor1

        Item {
            id: selectedItemContainer
            anchors.fill: parent
        }

        StatusIcon {
            id: caret
            anchors.right: parent.right
            anchors.rightMargin: caretRightMargin
            anchors.verticalCenter: parent.verticalCenter
            width: Theme.dp(24)
            height: Theme.dp(24)
            icon: "chevron-down"
            color: Theme.palette.baseColor1
        }
    }

    Rectangle {
        width: selectMenu.width
        height: selectMenu.height
        x: selectMenu.x
        y: selectMenu.y
        visible: selectMenu.opened
        color: Theme.palette.statusSelect.menuItemBackgroundColor
        radius: Theme.dp(8)
        border.color: Theme.palette.baseColor2
        layer.enabled: true
        layer.effect: DropShadow {
            verticalOffset: Theme.dp(3)
            radius: Theme.dp(8)
            samples: 15
            fast: true
            cached: true
            color: Theme.palette.dropShadow
        }
    }

    StatusPopupMenu {
        id: selectMenu
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        width: parent.width
        clip: true

        Repeater {
            id: menuItems
            model: root.model
            property int zeroItemsViewHeight
            delegate: selectMenu.delegate
            onItemAdded: {
                root.zeroItemsView.visible = false
                root.zeroItemsView.height = 0
            }
            onItemRemoved: {
                if (count === 0) {
                    root.zeroItemsView.visible = true
                    root.zeroItemsView.height = zeroItemsViewHeight
                }
            }
            Component.onCompleted: {
                zeroItemsViewHeight = root.zeroItemsView.height
                root.zeroItemsView.visible = count === 0
                root.zeroItemsView.height = count !== 0 ? 0 : root.zeroItemsView.height
                selectMenu.insertItem(0, root.zeroItemsView)
            }
        }
    }

    StatusBaseText {
        id: validationErrorText
        visible: !!validationError
        text: validationError
        anchors.top: inputRectangle.bottom
        anchors.topMargin: validationErrorTopMargin
        anchors.right: parent.right
        anchors.left: parent.left
        font.pixelSize: Theme.dp(12)
        height: visible ? implicitHeight : 0
        color: Theme.palette.dangerColor1
        horizontalAlignment: TextEdit.AlignRight
        wrapMode: Text.WordWrap
    }

    MouseArea {
        id: mouseArea
        anchors.fill: inputRectangle
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onEntered: {
            inputRectangle.hovered = true
        }
        onExited: {
            inputRectangle.hovered = false
        }
        onClicked: {
            if (selectMenu.opened) {
                selectMenu.close()
            } else {
                const rightOffset = inputRectangle.width - selectMenu.width
                let offset = rightOffset
                switch (root.menuAlignment) {
                    case StatusSelect.MenuAlignment.Left:
                        offset = 0
                        break
                    case StatusSelect.MenuAlignment.Right:
                        offset = rightOffset
                        break
                    case StatusSelect.MenuAlignment.Center:
                        offset = rightOffset / 2
                }
                selectMenu.popup(inputRectangle.x + offset, inputRectangle.y + inputRectangle.height + 8)
            }
        }
    }
}

