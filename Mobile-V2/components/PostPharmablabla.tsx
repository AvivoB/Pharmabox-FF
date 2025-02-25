import { styles } from '@/assets/style/stylesheet';
import MaterialIcons from '@expo/vector-icons/MaterialIcons';
import React from 'react';
import { View, Text, Image } from 'react-native';


interface PostPharmablablaProps {
    id: number;
    name: string;
    post: string;
    likes: number;
    comments: number;
}

export const PostPharmablabla = ({ id, name, post, likes, comments } : PostPharmablablaProps) => {
  return (
    <View style={styles.post_pharmablabla}>
        <View style={styles.post_pharmablabla_content}>
            <View style={[styles.flex, styles.flex_row, styles.align_start]}>
                <View>
                    <Image source={require('@/assets/images/Avatar.png')} style={{ width: 40, height: 40, borderRadius: 30 }} />
                </View>
                <View style={{ paddingLeft: 10 }}>
                    <Text style={styles.card_title}>{name}</Text>
                    <Text style={styles.description}>{name}</Text>
                </View>
            </View>
            <View><Text style={[styles.description]}>{post}</Text></View>
        </View>
        <View style={[styles.post_pharmablabla_bottom, styles.flex, styles.flex_row, styles.item_between, styles.align_center]}>
            <View style={[styles.comments_likes_btn]}>
                <MaterialIcons name='recommend' size={20} style={{ paddingRight: 10 }} />
                <Text>{likes}</Text>
            </View>
            <View>
                <Text>Thème</Text>
            </View>
            <View style={[styles.comments_likes_btn]}>
                <MaterialIcons name='subject' size={20} style={{ paddingRight: 10 }} />
                <Text>{comments}</Text>
            </View>
        </View>
    </View>
  );
};
