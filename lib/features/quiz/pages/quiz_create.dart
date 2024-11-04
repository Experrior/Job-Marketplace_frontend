import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class QuizCreationPage extends HookConsumerWidget {
  QuizCreationPage({super.key});

  static const String route = 'quiz_create';

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final timeLimitController = useTextEditingController();
    final timeCountingType = useState<String>('Total');
    final canGoBack = useState<bool>(false);
    final questions = useState<List<Map<String, dynamic>>>([]);

    void addQuestion() {
      questions.value = [
        ...questions.value,
        {
          'textController': TextEditingController(),
          'type': 'Single Correct Answer',
          'answers': List.generate(
              4,
              (_) =>
                  {'controller': TextEditingController(), 'isCorrect': false}),
        }
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Quiz'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name Field
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Quiz Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Quiz name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Time Counting Type Field
                DropdownButtonFormField<String>(
                  value: timeCountingType.value,
                  items: ['Total', 'Per Question'].map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  decoration:
                      const InputDecoration(labelText: 'Time Counting Type'),
                  onChanged: (value) {
                    timeCountingType.value = value!;
                  },
                ),
                const SizedBox(height: 16),

                // Time Limit Field
                TextFormField(
                  controller: timeLimitController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Time Limit (seconds)',
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        int.tryParse(value) == null) {
                      return 'Enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Can Go Back Field
                Row(
                  children: [
                    Checkbox(
                      value: canGoBack.value,
                      onChanged: (value) {
                        canGoBack.value = value!;
                      },
                    ),
                    const Text('Can go back to previous question'),
                  ],
                ),
                const SizedBox(height: 16),

                // Add Question Button
                ElevatedButton.icon(
                  onPressed: addQuestion,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Question'),
                ),
                const SizedBox(height: 16),

                // List of Questions
                ...questions.value.map((question) {
                  int questionIndex = questions.value.indexOf(question);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Question ${questionIndex + 1}',
                            style: Theme.of(context).textTheme.subtitle1),
                        const SizedBox(height: 8),

                        // Question Text Field
                        TextFormField(
                          controller: question['textController'],
                          decoration: const InputDecoration(
                            labelText: 'Question Text',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Question text is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),

                        // Question Type Field
                        DropdownButtonFormField<String>(
                          value: question['type'],
                          items: [
                            'Single Correct Answer',
                            'Multiple Correct Answers'
                          ].map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          decoration:
                              const InputDecoration(labelText: 'Question Type'),
                          onChanged: (value) {
                            question['type'] = value!;
                          },
                        ),
                        const SizedBox(height: 8),

                        // Answer Options
                        Column(
                          children: List.generate(4, (index) {
                            return Row(
                              children: [
                                Checkbox(
                                  value: question['answers'][index]
                                      ['isCorrect'],
                                  onChanged: (value) {
                                    question['answers'][index]['isCorrect'] =
                                        value!;
                                  },
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: question['answers'][index]
                                        ['controller'],
                                    decoration: InputDecoration(
                                      labelText: 'Answer ${index + 1}',
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  );
                }).toList(),

                const SizedBox(height: 16),

                // Submit Button
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // Submit quiz data
                    }
                  },
                  child: const Text('Create Quiz'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
