import QtQuick 2.14
import QtQuick.Layouts 1.14

import StatusQ.Core 0.1
import StatusQ.Core.Theme 0.1
import StatusQ.Components 0.1
import StatusQ.Controls 0.1

Item {
    id: root

    property StatusMessageSenderDetails sender: StatusMessageSenderDetails { }

    property alias displayNameLabel: primaryDisplayName
    property alias secondaryNameLabel: secondaryDisplayName
    property alias tertiaryDetailsLabel: tertiaryDetailText
    property alias timestamp: timestampText

    property string tertiaryDetail: sender.id
    property string resendText: ""
    property bool showResendButton: false
    property bool isMutualContact: sender.isMutualContact
    property int trustIndicator: sender.trustIndicator

    signal clicked()
    signal resendClicked()

    height: childrenRect.height
    width: primaryDisplayName.width + (secondaryDisplayName.visible ? secondaryDisplayName.width + header.spacing : 0)

    RowLayout {
        id: header
        spacing: 4
        TextEdit {
            id: primaryDisplayName
            font.family: Theme.palette.baseFont.name
            font.weight: Font.Medium
            font.pixelSize: 15
            font.underline: mouseArea.containsMouse
            readOnly: true
            wrapMode: Text.WordWrap
            selectByMouse: true
            color: Theme.palette.primaryColor1
            text: root.sender.displayName
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                hoverEnabled: true
                onClicked: {
                    root.clicked()
                }
            }
            Layout.alignment: Qt.AlignBottom
        }       
        StatusContactVerificationIcons {
            isMutualContact: root.isMutualContact
            trustIndicator: root.trustIndicator
        }
        StatusBaseText {
            id: secondaryDisplayName
            Layout.alignment: Qt.AlignVCenter
            color: Theme.palette.baseColor1
            font.pixelSize: 10
            text: `(${root.sender.secondaryName})`
            visible: !!root.sender.secondaryName
        }
        StatusBaseText {
            id: dotSeparator1
            Layout.fillHeight: true
            font.pixelSize: 10
            color: Theme.palette.baseColor1
            text: "."
            visible: secondaryDisplayName.visible
        }
        StatusBaseText {
            id: tertiaryDetailText
            Layout.alignment: Qt.AlignVCenter
            Layout.maximumWidth: 58
            font.pixelSize: 10
            elide: Text.ElideMiddle
            color: Theme.palette.baseColor1
            text: tertiaryDetail
        }
        StatusBaseText {
            id: dotSeparator2
            Layout.fillHeight: true
            font.pixelSize: 10
            color: Theme.palette.baseColor1
            text: "."
            visible: tertiaryDetailText.visible
        }
        StatusTimeStampLabel {
            id: timestampText
        }
        StatusBaseText {
            Layout.alignment: Qt.AlignVCenter
            color: Theme.palette.dangerColor1
            font.pixelSize: 12
            text: root.resendText
            visible: showResendButton && !!timestampText.text
            MouseArea {
                cursorShape: Qt.PointingHandCursor
                anchors.fill: parent
                onClicked: root.resendClicked()
            }
        }
    }
}
