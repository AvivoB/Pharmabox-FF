import { styles } from '@/assets/style/stylesheet';
import MaterialIcons from '@expo/vector-icons/MaterialIcons';
import React, { useState } from 'react';
import { View, Text, TouchableOpacity } from 'react-native';


export const LikeButton = ({ docId, count, isLikedByMe }) => {

    const [liked, setIsLiked] = useState(isLikedByMe);
    const [likesCount, setLikesCount] = useState(parseInt(count));

    const likeItem = async (docId) => {
        // Call the like function
        setIsLiked(!liked);
        if(liked) {
            setLikesCount(likesCount - 1);
        } else {
            setLikesCount(likesCount + 1);
        }
    }


  return (
    <View style={[styles.comments_likes_btn]}>
        <TouchableOpacity className='flex flex-row' onPress={() => likeItem(docId)}>
            <MaterialIcons name='recommend' size={20} className={`mr-2 ${liked ? 'text-blue_100' : ''}`} />
            <Text className={`${liked ? 'text-blue_100' : ''}`}>{likesCount > 0 ? likesCount : '  '}</Text>
        </TouchableOpacity>
    </View>
  );
};
