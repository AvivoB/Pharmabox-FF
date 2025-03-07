import { StyleSheet } from "react-native";
import {globalColors} from "./colors.ts";
import { auth } from "@/common/firebase.js";

export const styles = StyleSheet.create({
    container: {
        padding: 20,
        height: '100%',
    },
    auth_container: {
        padding: 0,
        height: '100%',
        justifyContent: 'center',
    },
    h1: {
        fontSize: 38,
        color: globalColors.black_100,
        lineHeight: 40,
        fontFamily: 'Poppins_700Bold'
    },
    h2: {
        fontSize: 32,
        color: globalColors.black_100,
        lineHeight: 36,
        fontFamily: 'Poppins_500Medium'
    },
    h3: {
        fontSize: 20,
        lineHeight:12,
        color: globalColors.black_100,
        fontFamily: 'Poppins_500Medium'
    },
    description: {
        fontSize: 14,
        fontFamily: 'Poppins_400Regular',
        color: globalColors.grey_100,
        paddingTop: 10,
        paddingBottom: 10,
        lineHeight: 22,
    },
    btnPrimary: {
        backgroundColor: globalColors.blue_100,
        padding: 16,
        borderRadius: 0,
        marginTop: 10,
        alignItems: "center",
        color: globalColors.white_100,
        textAlign: "center",
        fontFamily: 'Poppins_600SemiBold',
        fontSize: 16
    },
    btnSecondary: {
        backgroundColor: globalColors.white_100,
        color: globalColors.black_100,
        padding: 16,
        borderRadius: 0,
        marginTop: 10,
        alignItems: "center",
        textAlign: "center",
        fontFamily: 'Poppins_600SemiBold',
    },
    btnSecondaryOutline: {
        backgroundColor: "transparent",
        borderColor: globalColors.blue_100,
        borderWidth: 1,
        color: globalColors.blue_100,
        padding: 16,
        borderRadius: 0,
        marginTop: 10,
        alignItems: "center",
        textAlign: "center",
        fontFamily: 'Poppins_600SemiBold',
    },
    loader: {
        color: globalColors.white_100,

    },
    inputContainer: {
        marginTop: 16,
        marginBottom: 16,
    },
    input: {
        backgroundColor: globalColors.white_100,
        padding: 15,
        borderRadius: 0,
        alignItems: "center",
        outlineColor: globalColors.blue_100,
        outlineWidth: 1,
        color: globalColors.black_100,
        fontFamily: 'Poppins_400Regular',
        borderColor: globalColors.grey_110,
        borderWidth: 1,
    },
    label: {
        color: globalColors.black_100,
        fontFamily: 'Poppins_600SemiBold',
    },
    input_placeholder: {
        color: globalColors.grey_110,
        fontFamily: 'Poppins_400Regular',
    },
    input_error: {
        backgroundColor: globalColors.white_100,
        padding: 15,
        borderRadius: 0,
        marginTop: 10,
        alignItems: "center",
        outlineStyle: "none",
        color: globalColors.black_100,
        fontFamily: 'Poppins_400Regular',
        borderColor: globalColors.red_100,
        borderWidth: 1,
    },
    input_focused: {
        backgroundColor: globalColors.white_100,
        padding: 15,
        borderRadius: 0,
        marginTop: 10,
        alignItems: "center",
        borderColor: globalColors.blue_100,
        borderWidth: 1,
        // outlineWidth: 1, 
        color: globalColors.black_100,
        fontFamily: 'Poppins_400Regular',
    },
    label_input_error: {
        color: globalColors.red_100,
        fontFamily: 'Poppins_400Regular',
        fontSize: 12,
        marginTop: 5,
    },
    input_select: {
        marginTop: 5,
        marginBottom: 5,
        padding: 10,
        borderColor: globalColors.grey_110,
        borderWidth: 1,
        fontFamily: 'Poppins_400Regular',
    },
    input_select_selected: {
        marginTop: 5,
        marginBottom: 5,
        padding: 10,
        borderColor: globalColors.blue_100,
        color: globalColors.blue_100,
        borderWidth: 1,
        fontFamily: 'Poppins_500Medium',
    },
    container_otp: {
        marginTop: 20,
        marginBottom: 20,
    },
    container_input_otp: {
        flexDirection: 'row',
        width: '100%',
        gap: 15,
    },
    sidebar: {
        width: '100%',
        backgroundColor: globalColors.white_100,
        height: '100%',
        padding: 10,
    },
    bg_white: {
        backgroundColor: globalColors.white_100,
    },
    hide_mobile: {
        display: 'none',
    },
    flex: {
        // basis
        flex: 1,
    },
    flex_row: {
        flexDirection: 'row',
    },
    item_center: {
        alignItems: 'center',
    },
    items_end : {
        justifyContent: 'flex-end',
    },
    item_between: {
        justifyContent: 'space-between',
    },
    align_center: {
        // vertical
        alignItems: 'center',
    },
    align_end: {
        // vertical
        justifyContent: 'flex-end',
    },
    align_start: {
        // vertical
        justifyContent: 'flex-start',
    },
    nav_item : {
        padding: 10,
        color: globalColors.black_100,
        fontFamily: 'Poppins_400Regular',
    },
    nav_item_active: {
        color: globalColors.green_100,
    },
    bg_account_navbar: {
        backgroundColor: globalColors.white_100,
        padding: 20,
        marginBottom: 20,
        borderRadius: 5,
        flexDirection: 'row',
        justifyContent: 'flex-end',
        flexBasis: 5,
    },
    post_pharmablabla: {
        backgroundColor: globalColors.white_100,
        marginBottom: 20,
        borderRadius: 5,
        shadowColor: globalColors.grey_110,
        shadowOffset: { width: 0, height: 2 },
    },
    post_pharmablabla_content: {
        padding: 20,
    },
    post_pharmablabla_bottom: {
        marginTop: 10,
        backgroundColor: globalColors.green_110,
        padding: 10,
        borderBottomLeftRadius: 5,
        borderBottomRightRadius: 5,
    },
    card_title: {
        fontSize: 16,
        lineHeight: 0,
        fontFamily: 'Poppins_500Medium',
        color: globalColors.black_100,
    },
    comments_likes_btn: {
        flexDirection: 'row',
        alignItems: 'center',
        backgroundColor: globalColors.white_100,
        paddingHorizontal: 20,
        paddingVertical: 10,
        borderRadius: 50,
        fontSize: 16,
        fontFamily: 'Poppins_400Regular',
    },
});

export const widthRender = (percentage: number, mobile) => {
    return {
        width: `${percentage}%`
    };
};