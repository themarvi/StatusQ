import QtQuick 2.14
import QtQuick.Layouts 1.14
import QtQml.Models 2.14

import StatusQ.Core 0.1
import StatusQ.Core.Theme 0.1
import StatusQ.Controls 0.1

Item {
    id: root

    property ObjectModel customButtons

    property alias closeButton: closeButton
    property alias infoButton: infoButton

    height: implicitHeight
    width: implicitWidth
    implicitHeight: layout.implicitHeight
    implicitWidth: layout.implicitWidth

    RowLayout {
        id: layout

        anchors.fill: parent

        Repeater {
            model: root.customButtons
            onItemAdded: {
                item.Layout.fillHeight = true
                item.Layout.preferredHeight = 32
                item.Layout.preferredWidth = 32
            }
        }

        StatusFlatRoundButton {
            id: infoButton

            Layout.fillHeight: true
            Layout.preferredHeight: 32
            Layout.preferredWidth: 32

            visible: false

            type: StatusFlatRoundButton.Type.Secondary
            icon.name: "info"
            icon.color: Theme.palette.directColor1
            icon.width: 20
            icon.height: 20
        }

        StatusFlatRoundButton {
            id: closeButton

            Layout.fillHeight: true
            Layout.preferredHeight: 32
            Layout.preferredWidth: 32

            type: StatusFlatRoundButton.Type.Secondary
            icon.name: "close"
            icon.color: Theme.palette.directColor1
            icon.width: 20
            icon.height: 20
        }
    }
}
