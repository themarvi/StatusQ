import QtQuick 2.14
import QtQuick.Shapes 1.13
import QtGraphicalEffects 1.13
import QtQuick.Layouts 1.14

import StatusQ.Core 0.1
import StatusQ.Core.Theme 0.1
import StatusQ.Components 0.1

Loader {
    id: chatReply

    property StatusMessageDetails replyDetails
    property string audioMessageInfoText: ""

    signal replyProfileClicked()

    active: visible

    sourceComponent: RowLayout {
        id: replyLayout
        spacing: Theme.dp(8)
        Shape {
            id: replyCorner
            Layout.alignment: Qt.AlignTop
            Layout.leftMargin: Theme.dp(35)
            Layout.topMargin: profileImage.height/2
            Layout.preferredWidth: Theme.dp(20)
            Layout.preferredHeight: messageLayout.height - replyCorner.Layout.topMargin
            asynchronous: true
            antialiasing: true
            ShapePath {
                strokeColor: Qt.hsla(Theme.palette.baseColor1.hslHue, Theme.palette.baseColor1.hslSaturation, Theme.palette.baseColor1.hslLightness, 0.4)
                strokeWidth: 3
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                joinStyle: ShapePath.RoundJoin
                startX: Theme.dp(20)
                startY: 0
                PathLine { x: Theme.dp(10); y: 0 }
                PathArc {
                    x: 0; y: Theme.dp(10)
                    radiusX: Theme.dp(13)
                    radiusY: Theme.dp(13)
                    direction: PathArc.Counterclockwise
                }
                PathLine { x: 0; y: messageLayout.height}
            }
        }
        ColumnLayout {
            id: messageLayout
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: Theme.dp(4)
            RowLayout {
                StatusSmartIdenticon {
                    id: profileImage
                    Layout.alignment: Qt.AlignTop
                    image: replyDetails.profileImage
                    name: replyDetails.displayName
                    MouseArea {
                        cursorShape: Qt.PointingHandCursor
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        anchors.fill: parent
                        onClicked: replyProfileClicked()
                    }
                }
                TextEdit {
                    Layout.alignment: Qt.AlignVCenter
                    color: Theme.palette.baseColor1
                    selectionColor: Theme.palette.primaryColor3
                    selectedTextColor: Theme.palette.directColor1
                    font.pixelSize: Theme.dp(13)
                    font.weight: Font.Medium
                    selectByMouse: true
                    readOnly: true
                    text: replyDetails.displayName
                }
            }
            StatusTextMessage {
                Layout.fillWidth: true
                textField.text: replyDetails.messageText
                textField.font.pixelSize: Theme.dp(13)
                textField.color: Theme.palette.baseColor1
                textField.height: Theme.dp(18)
                clip: true
                visible: !!replyDetails.messageText
            }
            StatusImageMessage {
                Layout.fillWidth: true
                Layout.preferredHeight: imageAlias.paintedHeight
                imageWidth: Theme.dp(56)
                source: replyDetails.contentType === StatusMessage.ContentType.Image ? replyDetails.messageContent : ""
                visible: replyDetails.contentType === StatusMessage.ContentType.Image
                shapeType: StatusImageMessage.ShapeType.ROUNDED
            }
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.dp(48)
                Layout.alignment: Qt.AlignLeft
                visible: replyDetails.contentType === StatusMessage.ContentType.Sticker
                StatusSticker {
                    image.width: Theme.dp(48)
                    image.height: Theme.dp(48)
                    image.source: replyDetails.messageContent
                }
            }
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.dp(22)
                visible: replyDetails.contentType === StatusMessage.ContentType.Audio
                StatusAudioMessage {
                    id: audioMessage
                    anchors.left: parent.left
                    width: Theme.dp(125)
                    height: Theme.dp(22)
                    isPreview: true
                    audioSource: replyDetails.messageContent
                    audioMessageInfoText: chatReply.audioMessageInfoText
                }
            }
        }
    }
}

