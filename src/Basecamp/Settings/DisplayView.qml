import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Logos.Controls
import Logos.Theme

// Text size and contrast, kept in the design system's settings so every app
// that uses Logos.Theme follows them.
Item {
    id: root

    readonly property var sizes: [
        { label: qsTr("Small"),   scale: 0.9 },
        { label: qsTr("Default"), scale: 1.0 },
        { label: qsTr("Large"),   scale: 1.2 },
        { label: qsTr("Larger"),  scale: 1.4 }
    ]

    LogosScrollView {
        id: scroll
        anchors.fill: parent
        anchors.margins: Theme.spacing.xxlarge
        clip: true

        ColumnLayout {
            width: scroll.availableWidth
            spacing: Theme.spacing.xlarge

            LogosText {
                text: qsTr("Display")
                font.pixelSize: Theme.typography.panelTitleText
                font.weight: Theme.typography.weightBold
                color: Theme.palette.text
            }

            ColumnLayout {
                spacing: Theme.spacing.small

                LogosText {
                    text: qsTr("Text size")
                    font.pixelSize: Theme.typography.subtitleText
                    color: Theme.palette.text
                }

                Repeater {
                    model: root.sizes
                    delegate: LogosRadioButton {
                        objectName: "settings.display.size." + index
                        text: modelData.label
                        checked: Math.abs(Theme.textScale - modelData.scale) < 0.01
                        onClicked: Theme.setTextScale(modelData.scale)
                    }
                }
            }

            RowLayout {
                spacing: Theme.spacing.medium

                ColumnLayout {
                    spacing: Theme.spacing.tiny
                    LogosText {
                        text: qsTr("High contrast")
                        font.pixelSize: Theme.typography.subtitleText
                        color: Theme.palette.text
                    }
                    LogosText {
                        text: qsTr("Brighter text and borders on a black background.")
                        font.pixelSize: Theme.typography.primaryText
                        color: Theme.palette.textSecondary
                    }
                }

                LogosSwitch {
                    objectName: "settings.display.contrast"
                    checked: Theme.currentTheme === "high-contrast"
                    onToggled: Theme.setTheme(checked ? "high-contrast" : "dark")
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: preview.implicitHeight + 2 * Theme.spacing.large
                color: Theme.palette.background
                border.color: Theme.palette.border
                radius: Theme.spacing.radiusLarge

                ColumnLayout {
                    id: preview
                    anchors.fill: parent
                    anchors.margins: Theme.spacing.large
                    spacing: Theme.spacing.tiny
                    LogosText {
                        text: qsTr("Preview")
                        font.pixelSize: Theme.typography.titleText
                        font.weight: Theme.typography.weightBold
                        color: Theme.palette.text
                    }
                    LogosText {
                        text: qsTr("Body text looks like this.")
                        font.pixelSize: Theme.typography.primaryText
                        color: Theme.palette.text
                    }
                    LogosText {
                        text: qsTr("Secondary text looks like this.")
                        font.pixelSize: Theme.typography.secondaryText
                        color: Theme.palette.textSecondary
                    }
                }
            }
        }
    }
}
