import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GeminiService {
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';
  
  // Default API key - users can override this in settings
  static const String _defaultApiKey = 'YOUR_API_KEY_HERE'; // Replace with your actual API key
  
  static Future<String> _getApiKey() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedKey = prefs.getString('gemini_api_key');
      return savedKey ?? _defaultApiKey;
    } catch (e) {
      return _defaultApiKey;
    }
  }
  
  static void setApiKey(String apiKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('gemini_api_key', apiKey);
    } catch (e) {
      // Handle error silently
    }
  }
  
  /// Test if an API key is valid
  static Future<bool> testApiKey(String apiKey) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [{
            'parts': [{
              'text': 'Hello, are you working?'
            }]
          }],
          'generationConfig': {
            'temperature': 0.7,
            'maxOutputTokens': 10,
          }
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
  
  static Future<String> analyzeDocument({
    required String extractedText,
    String? documentType,
    String? userPrompt,
  }) async {
    final apiKey = await _getApiKey();
    
    final prompt = _buildAnalysisPrompt(extractedText, documentType, userPrompt);
    
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 1,
            'topP': 1,
            'maxOutputTokens': 2048,
          }
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          return data['candidates'][0]['content']['parts'][0]['text'];
        } else {
          throw Exception('No response from Gemini API');
        }
      } else {
        throw Exception('Gemini API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to analyze document: $e');
    }
  }
  
  static Future<Map<String, dynamic>> extractStructuredData({
    required String extractedText,
    String? documentType,
  }) async {
    final apiKey = await _getApiKey();
    
    final prompt = _buildExtractionPrompt(extractedText, documentType ?? 'Document');
    
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.3,
            'topK': 1,
            'topP': 1,
            'maxOutputTokens': 2048,
          }
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          final responseText = data['candidates'][0]['content']['parts'][0]['text'];
          return _parseStructuredResponse(responseText);
        } else {
          throw Exception('No response from Gemini API');
        }
      } else {
        throw Exception('Gemini API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to extract structured data: $e');
    }
  }
  
  /// Advanced form field detection and auto-fill with AI
  static Future<Map<String, dynamic>> detectFormFields({
    required String extractedText,
    String? formType,
  }) async {
    final apiKey = await _getApiKey();
    
    final prompt = '''
You are an advanced form analysis AI. Analyze this extracted text from a ${formType ?? 'document'} and detect all possible form fields with intelligent auto-fill suggestions.

EXTRACTED TEXT:
$extractedText

Identify and extract data for these field categories:
1. PERSONAL INFO: Name, Gender, Date of Birth, Age, Marital Status
2. CONTACT: Phone, Email, Address (Full/Permanent/Current), PIN/ZIP Code, State, City, Country
3. IDENTITY: Aadhar Number, PAN, Passport, Driving License, Voter ID
4. EDUCATION: Qualification, Institution, Year of Passing, Marks/Percentage, Course
5. EMPLOYMENT: Occupation, Company, Experience, Salary, Department
6. FAMILY: Father Name, Mother Name, Spouse Name, Emergency Contact
7. FINANCIAL: Bank Account, IFSC Code, Annual Income, IT Return Filed
8. GOVERNMENT: Ration Card, BPL Status, Caste Category, Religion
9. DATES: Any important dates, deadlines, or time periods

Return ONLY a valid JSON object with this exact structure:
{
  "detected_fields": {
    "field_name": {
      "value": "extracted_value",
      "confidence": 0.95,
      "field_type": "text|number|date|email|phone|dropdown",
      "category": "personal|contact|identity|education|employment|family|financial|government|dates"
    }
  },
  "form_type_detected": "application|government|banking|education|employment|healthcare|other",
  "completion_percentage": 85,
  "missing_common_fields": ["field1", "field2"],
  "suggestions": ["Suggestion 1", "Suggestion 2"]
}
''';
    
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.2,
            'topK': 1,
            'topP': 1,
            'maxOutputTokens': 3000,
          }
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          final responseText = data['candidates'][0]['content']['parts'][0]['text'];
          return _parseFormFieldsResponse(responseText);
        } else {
          throw Exception('No response from Gemini API');
        }
      } else {
        throw Exception('Gemini API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to detect form fields: $e');
    }
  }

  /// Generate intelligent auto-fill suggestions for specific field types
  static Future<List<String>> generateSmartSuggestions({
    required String fieldName,
    required String fieldType,
    required String extractedText,
    String? currentValue,
  }) async {
    final apiKey = await _getApiKey();
    
    final prompt = '''
Generate intelligent auto-fill suggestions for the field "$fieldName" of type "$fieldType".

EXTRACTED TEXT CONTEXT:
$extractedText

CURRENT VALUE: ${currentValue ?? 'Not provided'}

Based on the extracted text, provide 3-5 relevant suggestions for this field.
Consider:
- Common variations of the data
- Formatted versions (dates, phone numbers, addresses)
- Alternative representations
- Error corrections if needed

Return only the suggestions, one per line, without labels or explanations.
''';
    
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.4,
            'topK': 1,
            'topP': 1,
            'maxOutputTokens': 512,
          }
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          final responseText = data['candidates'][0]['content']['parts'][0]['text'];
          return responseText.split('\n')
              .where((line) => line.trim().isNotEmpty)
              .take(5)
              .toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Gemini API error: ${response.statusCode}');
      }
    } catch (e) {
      return ['Error generating suggestions: $e'];
    }
  }

  static Future<List<String>> generateFormSuggestions({
    required String extractedText,
    required String formContext,
  }) async {
    final apiKey = await _getApiKey();
    
    final prompt = '''
Analyze this extracted text from a document and suggest how to fill form fields for $formContext:

EXTRACTED TEXT:
$extractedText

Please provide suggestions for common form fields like:
- Name
- Address
- Phone
- Email
- Date of Birth
- ID Numbers
- Other relevant information

Return only a list of practical suggestions, one per line, in the format:
Field: Suggested Value

Example:
Name: John Smith
Address: 123 Main St, City, State 12345
Phone: (555) 123-4567
''';
    
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.5,
            'topK': 1,
            'topP': 1,
            'maxOutputTokens': 1024,
          }
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          final responseText = data['candidates'][0]['content']['parts'][0]['text'];
          return responseText.split('\n')
              .where((line) => line.trim().isNotEmpty && line.contains(':'))
              .toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Gemini API error: ${response.statusCode}');
      }
    } catch (e) {
      return ['Error generating suggestions: $e'];
    }
  }
  
  static String _buildAnalysisPrompt(String text, String? docType, String? userPrompt) {
    return '''
You are an intelligent document analysis assistant. Analyze the following extracted text and provide useful insights.

DOCUMENT TYPE: ${docType ?? 'Unknown'}
EXTRACTED TEXT:
$text

${userPrompt ?? '''
Please provide:
1. Document summary
2. Key information extracted
3. Potential uses for this information
4. Any suggestions for form filling or data organization

Be concise and practical in your response.'''}
''';
  }
  
  static String _buildExtractionPrompt(String text, String docType) {
    return '''
Extract structured data from this $docType document text. Return the response in JSON format with relevant fields:

EXTRACTED TEXT:
$text

Please identify and extract:
- Personal information (names, dates, addresses)
- ID numbers or reference numbers
- Dates and deadlines
- Contact information
- Any other structured data

Return as valid JSON only, no additional text.
Example format:
{
  "name": "extracted name",
  "address": "extracted address",
  "phone": "extracted phone",
  "email": "extracted email",
  "id_number": "extracted ID",
  "dates": ["extracted dates"],
  "other_info": {}
}
''';
  }
  
  static Map<String, dynamic> _parseFormFieldsResponse(String response) {
    try {
      // Try to extract JSON from the response
      final jsonStart = response.indexOf('{');
      final jsonEnd = response.lastIndexOf('}') + 1;
      
      if (jsonStart != -1 && jsonEnd > jsonStart) {
        final jsonString = response.substring(jsonStart, jsonEnd);
        final parsed = jsonDecode(jsonString);
        
        // Validate the structure
        if (parsed is Map<String, dynamic> && parsed.containsKey('detected_fields')) {
          return parsed;
        }
      }
      
      // Fallback: create a basic structure
      return {
        'detected_fields': {},
        'form_type_detected': 'unknown',
        'completion_percentage': 0,
        'missing_common_fields': [],
        'suggestions': ['Unable to parse form fields from document'],
        'raw_response': response,
        'parsed': false,
      };
    } catch (e) {
      return {
        'detected_fields': {},
        'form_type_detected': 'error',
        'completion_percentage': 0,
        'missing_common_fields': [],
        'suggestions': ['Error parsing form fields: $e'],
        'raw_response': response,
        'parsed': false,
        'error': e.toString(),
      };
    }
  }

  static Map<String, dynamic> _parseStructuredResponse(String response) {
    try {
      // Try to extract JSON from the response
      final jsonStart = response.indexOf('{');
      final jsonEnd = response.lastIndexOf('}') + 1;
      
      if (jsonStart != -1 && jsonEnd > jsonStart) {
        final jsonString = response.substring(jsonStart, jsonEnd);
        return jsonDecode(jsonString);
      } else {
        // Fallback: create structured data from text
        return {
          'raw_response': response,
          'parsed': false,
          'summary': response.length > 200 ? response.substring(0, 200) + '...' : response,
        };
      }
    } catch (e) {
      return {
        'error': 'Failed to parse response',
        'raw_response': response,
        'parsed': false,
      };
    }
  }
}