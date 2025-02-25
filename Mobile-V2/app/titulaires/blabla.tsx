import React from 'react';
import { View, Text, StyleSheet, ActivityIndicator, FlatList } from 'react-native';
import {styles, widthRender} from '@/assets/style/stylesheet';
import AuthLayout from '@/components/AuthLayout';
import { Input } from '@/components/Input';
import { Form } from '@/components/Form';
import { usePharmablabla } from '@/hooks/usePharmablabla';
import { PostPharmablabla } from '@/components/PostPharmablabla';


export default function Blabla() {

    const postData = [
        { id: 1, name: 'John Doe', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor.', likes: 10, comments: 5 },
        { id: 2, name: 'Jane Doe', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor.', likes: 10, comments: 5 },
        { id: 3, name: 'John Doe', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor.', likes: 10, comments: 5 },
        { id: 4, name: 'Jane Doe', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor.', likes: 10, comments: 5 },
        { id: 5, name: 'John Doe', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor.', likes: 10, comments: 5 },
    ];

  return (
    <AuthLayout>
        <View style={styles.container}>
            <Form onSubmit={(values) => console.log(values)}>
                <Input />
            </Form>
        <View style={widthRender(75)}>
        <FlatList
                data={postData}
                renderItem={({ item }) => PostPharmablabla({ id: item.id, name: item.name, post: item.description, likes: item.likes, comments: item.comments })}
                keyExtractor={(item) => item.id.toString()}
                onEndReachedThreshold={0.5}
            />
        </View>
        </View>
        
    </AuthLayout>
  );
};
