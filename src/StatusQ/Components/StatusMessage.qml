import QtQuick 2.14
import QtQuick.Layouts 1.14

import StatusQ.Core 0.1
import StatusQ.Core.Theme 0.1
import StatusQ.Controls 0.1

import "./private/statusMessage"

Rectangle {
    id: root

    enum ContentType {
        Unknown = 0,
        Text = 1,
        Emoji = 2,
        Image = 3,
        Sticker = 4,
        Audio = 5,
        Transaction = 6,
        Invitation = 7
    }

    property alias quickActions:quickActionsPanel.quickActions
    property alias statusChatInput: editComponent.inputComponent
    property alias linksComponent: linksLoader.sourceComponent
    property alias footerComponent: footer.sourceComponent

    property string resendText: ""
    property string cancelButtonText: ""
    property string saveButtonText: ""
    property string loadingImageText: ""
    property string errorLoadingImageText: ""
    property string audioMessageInfoText: ""
    property string pinnedMsgInfoText: ""

    property bool isAppWindowActive: false
    property bool editMode: false
    property bool isAReply: false

    property bool hasMention: false
    property bool isPinned: false
    property string pinnedBy: ""
    property bool hasExpired: false
    property string timestamp: ""

    property StatusMessageDetails messageDetails: StatusMessageDetails {}
    property StatusMessageDetails replyDetails: StatusMessageDetails {}

    property var timestampToString: (value) => {
                                        const parsed = parseInt(value, 10);
                                        return Qt.formatTime(new Date(parsed), "hh:mm");
                                    }

    property var timestampToTooltipString: (value) => {
                                               const parsed = parseInt(value, 10);
                                               return Qt.formatTime(new Date(parsed), "dddd, MMMM d, yyyy hh:mm:ss t");
                                           }

    signal profilePictureClicked()
    signal senderNameClicked()
    signal editCompleted(var newMsgText)
    signal replyProfileClicked()
    signal stickerLoaded()
    signal imageClicked(var imageSource)
    signal resendClicked()

    implicitWidth: messageLayout.implicitWidth
                    + messageLayout.anchors.leftMargin
                    + messageLayout.anchors.rightMargin

    implicitHeight: messageLayout.implicitHeight
                    + messageLayout.anchors.topMargin
                    + messageLayout.anchors.bottomMargin

    color: hoverHandler.hovered
           ? (root.hasMention
              ? Theme.palette.mentionColor3
              : root.isPinned
                ? Theme.palette.pinColor2
                :  Theme.palette.baseColor2)
           : root.hasMention
             ? Theme.palette.mentionColor4
             : root.isPinned
               ? Theme.palette.pinColor3
               : "transparent"

    Rectangle {
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
        }
        width: 2
        visible: root.isPinned || root.hasMention
        color: root.isPinned
               ? Theme.palette.pinColor1
               : root.hasMention
                 ? Theme.palette.mentionColor1
                 : "transparent"
    }

    HoverHandler {
        id: hoverHandler
    }

    ColumnLayout {
        id: messageLayout
        anchors.fill: parent
        anchors.bottomMargin: 8

        StatusMessageReply {
            Layout.fillWidth: true
            visible: isAReply
            replyDetails: root.replyDetails
            onReplyProfileClicked: root.replyProfileClicked()
            audioMessageInfoText: root.audioMessageInfoText
        }
        RowLayout {
            spacing: 8
            Layout.fillWidth: true
            StatusSmartIdenticon {
                id: profileImage

                Layout.alignment: Qt.AlignTop
                Layout.topMargin: 10
                Layout.leftMargin: 16

                name: messageDetails.sender.userName
                image: root.messageDetails.sender.profileImage.imageSettings
                icon: root.messageDetails.sender.profileImage.iconSettings
                ringSettings: root.messageDetails.sender.profileImage.ringSettings

                MouseArea {
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    anchors.fill: parent
                    onClicked: root.profilePictureClicked()
                }
            }
            Column {
                spacing: 4
                Layout.alignment: Qt.AlignTop
                Layout.topMargin: 10
                Layout.fillWidth: true
                StatusPinMessageDetails {
                    visible: root.isPinned && !editMode
                    pinnedMsgInfoText: root.pinnedMsgInfoText
                    pinnedBy: root.pinnedBy
                }
                StatusMessageHeader {
                    width: parent.width
                    sender: messageDetails.sender
                    resendText: root.resendText
                    showResendButton: root.hasExpired && messageDetails.amISender
                    onClicked: root.senderNameClicked()
                    onResendClicked: root.resendClicked()
                    visible: !editMode
                    timestamp.text: root.timestampToString(root.timestamp)
                    timestamp.tooltip.text: root.timestampToTooltipString(root.timestamp)
                }
                Loader {
                    active: !editMode && !!messageDetails.messageText
                    width: parent.width
                    visible: active
                    sourceComponent: StatusTextMessage {
                        width: parent.width
                        textField.text: messageDetails.messageText
                    }
                }
                Loader {
                    active: messageDetails.contentType === StatusMessage.ContentType.Image && !editMode
                    visible: active
                    sourceComponent: StatusImageMessage {
                        source: messageDetails.contentType === StatusMessage.ContentType.Image ? messageDetails.messageContent : ""
                        onClicked: root.imageClicked(source)
                        shapeType: messageDetails.amISender ? StatusImageMessage.ShapeType.RIGHT_ROUNDED : StatusImageMessage.ShapeType.LEFT_ROUNDED
                    }
                }
                StatusSticker {
                    visible: messageDetails.contentType === StatusMessage.ContentType.Sticker && !editMode
                    image.source: messageDetails.messageContent
                    onLoaded: root.stickerLoaded()
                }
                Loader {
                    active: messageDetails.contentType === StatusMessage.ContentType.Audio && !editMode
                    visible: active
                    sourceComponent: StatusAudioMessage {
                        audioSource: messageDetails.messageContent
                        hovered: hoverHandler.hovered
                        audioMessageInfoText: root.audioMessageInfoText
                    }
                }
                Loader {
                    id: linksLoader
                    active: !!linksLoader.sourceComponent
                    visible: active
                }
                Loader {
                    id: transactionBubbleLoader
                    active: messageDetails.contentType === StatusMessage.ContentType.Transaction && !editMode
                    visible: active
                }
                Loader {
                    id: invitationBubbleLoader
                    active: messageDetails.contentType === StatusMessage.ContentType.Invitation && !editMode
                    visible: active
                }
                StatusEditMessage {
                    id: editComponent
                    width: parent.width
                    msgText: messageDetails.messageText
                    visible: editMode
                    saveButtonText: root.saveButtonText
                    cancelButtonText: root.cancelButtonText
                    onCancelEditClicked: editMode = false
                    onEditCompleted: {
                        editMode = false
                        root.editCompleted(newMsgText)
                    }
                }
                StatusBaseText {
                    id: retryLbl
                    color: Theme.palette.dangerColor1
                    text: root.resendText
                    font.pixelSize: 12
                    visible: root.hasExpired && messageDetails.amISender && !root.timestamp && !editMode
                    MouseArea {
                        cursorShape: Qt.PointingHandCursor
                        anchors.fill: parent
                        onClicked: root.resendClicked()
                    }
                }
                Loader {
                    id: footer
                    active: sourceComponent && !editMode
                    visible: active
                }
            }
        }
    }

    StatusMessageQuickActions {
        id: quickActionsPanel
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.top: parent.top
        anchors.topMargin: -8
        visible: hoverHandler.hovered && !editMode
    }
}
