import QtQuick 2.0
import QtQuick.Layouts 1.14

import StatusQ.Core 0.1
import StatusQ.Core.Theme 0.1

/*!
   \qmltype StatusIconTextButton
   \inherits Item
   \inqmlmodule StatusQ.Controls
   \since StatusQ.Controls 0.1
   \brief It presents an icon + plain text button. Inherits \l{https://doc.qt.io/qt-6/qml-qtquick-item.html}{Item}.

   The \c StatusIconTextButton is a clickable icon + text control.

   Example of how the component looks like:
   \image status_icon_text_button.png
   Example of how to use it:
   \qml
        StatusIconTextButton {
            spacing: 0
            iconItem.icon: "next"
            iconItem.width: 12
            iconItem.height: iconItem.width
            iconItem.rotation: 180
            textItem.text: qsTr("Back")
            onClicked: console.log("Clicked!")
        }
   \endqml
   For a list of components available see StatusQ.
*/
Item {
    id: root

    /*!
       \qmlproperty string StatusIconTextButton::iconItem
       This property holds an alias to the icon item component.
    */
    property alias iconItem: iconItem

    /*!
       \qmlproperty string StatusIconTextButton::textItem
       This property holds an alias to the text item component.
    */
    property alias textItem: textItem
    /*!
       \qmlproperty string StatusIconTextButton::spacing
       This property holds the spacing between icon and text items.
    */
    property int spacing
    /*!
        \qmlsignal StatusIconTextButton::clicked()
        This signal is emitted when there is a click in the component area.
    */
    signal clicked()

    implicitHeight: row.implicitHeight
    implicitWidth: row.implicitWidth

    RowLayout {
        id: row
        spacing: root.spacing
        StatusIcon {
            id: iconItem
            Layout.alignment: Qt.AlignVCenter
            color: Theme.palette.primaryColor1
        }
        StatusBaseText {
            id: textItem
            Layout.alignment: Qt.AlignVCenter
            color: Theme.palette.primaryColor1
            font.pixelSize: 13
        }
    }
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: { root.clicked() }
    }
}
