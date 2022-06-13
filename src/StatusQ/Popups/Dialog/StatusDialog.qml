import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14
import QtQml.Models 2.14

import StatusQ.Core 0.1
import StatusQ.Controls 0.1
import StatusQ.Core.Theme 0.1

Dialog {
    id: root

    anchors.centerIn: Overlay.overlay

    padding: 16
    margins: 64
    modal: true

    standardButtons: Dialog.Cancel | Dialog.Ok

    Overlay.modal: Rectangle {
        color: Theme.palette.backdropColor
    }

    background: Rectangle {
        color: Theme.palette.statusModal.backgroundColor
        radius: 8
    }

    header: StatusDialogHeader {
        visible: root.title
        headline.title: root.title
        actions.closeButton.onClicked: root.close()
    }

    footer: StatusDialogFooter {
        visible: (root.standardButtons & Dialog.Cancel) ||
                 (root.standardButtons & Dialog.Ok)
        rightButtons: ObjectModel {
            StatusButton {
                visible: root.standardButtons & Dialog.Cancel
                text: qsTr("Cancel")
                type: StatusButton.Danger

                onClicked: root.reject()
            }
            StatusButton {
                visible: root.standardButtons & Dialog.Ok
                text: qsTr("Apply")

                onClicked: root.accept()
            }
        }
    }
}
