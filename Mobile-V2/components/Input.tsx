import React, { useState } from 'react';
import { View, Text, TextInput } from 'react-native';
import { styles } from '@/assets/style/stylesheet';
import { globalColors } from '@/assets/style/colors';
import { useForm } from './Form';

interface InputProps {
  name: string;
  label: string;
  type?: 'text' | 'password';
  placeholder?: string;
  keyboardType?: 'default' | 'number-pad' | 'decimal-pad' | 'numeric' | 'email-address' | 'phone-pad';
  formatter?: (text: string) => string;
  verifyer?: (text: string) => boolean;
  errorMessage?: string;
  searcher?: (text: string) => void;
}

export const Input = ({ name, label, type, placeholder, keyboardType, formatter, verifyer, errorMessage, searcher }: InputProps) => {
  const { values, errors, setFieldValue, setFieldError } = useForm();
  const [isFocused, setIsFocused] = useState(false);

  const onTextChange = (text: string) => {
    const formattedText = formatter ? formatter(text) : text;
    setFieldValue(name, formattedText);
  };

  const onBlurInput = () => {
    if (verifyer && !verifyer(values[name])) {
      setFieldError(name, errorMessage || 'Champ invalide');
    } else {
      setFieldError(name, '');
    }
  };


  return (
    <View style={styles.inputContainer}>
      <Text style={styles.label}>{label}</Text>
      <TextInput
        secureTextEntry={type === 'password'}
        keyboardType={keyboardType || 'default'}
        placeholderTextColor={globalColors.base_50}
        placeholder={placeholder}
        style={[
          styles.input,
          isFocused && styles.input_focused,
          errors[name] && styles.input_error
        ]}
        value={values[name] || ''}
        onChangeText={onTextChange}
        onFocus={() => setIsFocused(true)}
        onBlur={() => {
          onBlurInput();
          setIsFocused(false);
        }}
      />
      {errors[name] ? <Text style={styles.label_input_error}>{errors[name]}</Text> : null}
    </View>
  );
};

