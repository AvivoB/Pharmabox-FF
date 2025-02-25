import React, { useRef, useState } from 'react';
import { View, Text, TextInput } from 'react-native';
import { styles } from '@/assets/style/stylesheet';

interface InputOTPProps {
  name?: string;
  length?: number;
  onChangeOTP?: (otp: string) => void;
}

export const InputOTP = ({ length = 4, onChangeOTP }: InputOTPProps) => {
  const [otp, setOtp] = useState<string[]>(new Array(length).fill(''));
  const inputsRef = useRef<TextInput[]>([]);

  const handleChange = (text: string, index: number) => {
    if (!/^\d?$/.test(text)) return; // Only allow digits

    const newOtp = [...otp];
    newOtp[index] = text;
    setOtp(newOtp);

    // Call the parent function with OTP value
    onChangeOTP?.(newOtp.join(''));

    // Move to next input if a digit is entered
    if (text && index < length - 1) {
      inputsRef.current[index + 1]?.focus();
    }
  };

  const handleKeyPress = (key: string, index: number) => {
    if (key === 'Backspace' && index > 0 && !otp[index]) {
      inputsRef.current[index - 1]?.focus();
    }
  };

  return (
    <View style={styles.container_otp}>
      <Text style={styles.label}>Entrez le code reçu par SMS</Text>
      <View style={styles.container_input_otp}>
        {otp.map((digit, index) => (
          <TextInput
            
            key={index}
            ref={(el) => (inputsRef.current[index] = el!)}
            style={styles.input_otp}
            keyboardType="number-pad"
            maxLength={1}
            value={digit}
            onChangeText={(text) => handleChange(text, index)}
            onKeyPress={({ nativeEvent }) => handleKeyPress(nativeEvent.key, index)}
            textAlign="center"
            placeholder='X'
          />
        ))}
      </View>
    </View>
  );
};
