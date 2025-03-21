import { styles } from '@/assets/style/stylesheet';
import { formatDate, formatDateFirebase } from '@/common/formatters';
import MaterialIcons from '@expo/vector-icons/MaterialIcons';
import React from 'react';
import { View, Text, Image } from 'react-native';
import { Button } from './Button';
import { LikeButton } from './LikeButton';
import { router } from 'expo-router';


interface PostPharmablablaProps {
   item: any;
}

export const PostPharmablabla = ({ item } : PostPharmablablaProps) => {
  return (
    <View className='bg-white my-2 rounded-lg'>
        <View className='p-6'>
            <View className='flex flex-row justify-between'>
                <View className='flex flex-row'>
                    <View>
                        <Image source={ item.user?.photoUrl ?? require('@/assets/images/Avatar.png')} style={{ width: 40, height: 40, borderRadius: 30 }} />
                    </View>
                    <View className='ml-2'>
                        <Text className='text-xl font-semibold font-poppins'>{item.user?.nom +' '+ item.user?.prenom}</Text>
                        <Text className='text-md text-grey_100'>{item.user?.poste}</Text>
                    </View>
                </View>
                <View>
                    <Text className='text-grey_100'>{formatDateFirebase(item.date_created)}</Text>
                </View>
            </View>
            <View>
                <Text style={[styles.description]}
                onPress={() => {
                    router.push({ pathname: `/common/blabla/detail`, params: {item: JSON.stringify(item)} });
                  }}
                >
                    {item?.post_content}
                </Text>
            </View>
        </View>
        <View className='flex flex-row justify-between px-6 py-2 items-center bg-green_110 rounded-b-lg'>
            <LikeButton count={item?.likes} docId={item.id} isLikedByMe={item.isLikedByMe} />
            <View>
                <Text>{item?.theme != 'Thème' ? item.theme : '' }</Text>
            </View>
            <View style={[styles.comments_likes_btn]}>
                <MaterialIcons name='subject' size={20} className='mr-2 ' />
                <Text>{item?.comments}</Text>
            </View>
        </View>
    </View>
  );
};
