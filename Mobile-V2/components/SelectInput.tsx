import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity } from 'react-native';
import { styles } from '@/assets/style/stylesheet';
import { globalColors } from '@/assets/style/colors';
import { useForm } from './Form';

interface SelectProps {
  name: string;
  label: string;
  placeholder?: string;
  items: { value: string; label: string }[];
  verifyer?: (text: string) => boolean;
}

export const SelectInput = ({ name, label, items, verifyer }: SelectProps) => {
  const { values, errors, setFieldValue, setFieldError } = useForm();
  const [selectedValue, setSelectedValue] = useState('');

  return (
    <View style={styles.inputContainer}>
      <Text style={styles.label}>{label}</Text>
        {items.map((item, index) => (
          <TouchableOpacity
          style={ selectedValue === item.value ? styles.input_select_selected : styles.input_select}
          onPress={() => {
            setSelectedValue(item.value);
            setFieldValue(name, item.value);
          }}
        >
          <View
            style={{
              flexDirection: 'row',
              justifyContent: 'space-between',
            }}
          >
            <View>
              <Text>{item.value}</Text>
            </View>
            <View>
              <Text>{ selectedValue === item.value ? 'Ok' : '' }</Text>
            </View>
          </View>
        </TouchableOpacity>
        ))}
      {errors[name] ? <Text style={styles.label_input_error}>{errors[name]}</Text> : null}
    </View>
  );
};

