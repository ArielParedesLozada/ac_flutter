import 'package:acl_flutter/app/dtos/topic_update_dto.dart';
import 'package:acl_flutter/app/topic_service.dart';
import 'package:acl_flutter/domain/models/topic.dart';
import 'package:acl_flutter/presentation/widgets/topic_form.dart';
import 'package:flutter/material.dart';

class TopicItem extends StatelessWidget {
  final Topic topic;
  final VoidCallback? onReturn;

  const TopicItem({super.key, required this.topic, this.onReturn});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: const Color.fromARGB(255, 199, 230, 255),
      leading: const Icon(Icons.topic),
      title: Text(topic.name),
      subtitle: topic.description != null ? Text(topic.description!) : null,
      trailing: const Icon(Icons.edit_outlined),
      onTap: () => _showEditDialog(context),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 20, 24, 8),
                child: Text(
                  'Editar tema',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: TopicForm(
                    topic: topic,
                    onSubmit: (dto) async {
                      await TopicService().updateTopic(
                        topic.id!,
                        TopicUpdateDto(
                          name: dto.name,
                          description: dto.description,
                          startDate: dto.startDate,
                          endDate: dto.endDate,
                        ),
                      );
                      if (!context.mounted) return;
                      Navigator.pop(dialogContext);
                      onReturn?.call();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
