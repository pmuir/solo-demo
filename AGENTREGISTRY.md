```bash
source .env

```

### Demo

1. Scaffold a new agent

```bash
arctl agent init adk python --model-name gemini-2.5-flash diceagent --telemetry ${TELEMETRY_ENDPOINT}
```

2. Explore the agent - look at `agent.py`

3. Build and run the agent locally. Example prompts are: "What can you do" and "Roll a 6 sided die". Ctrl-c to exit

```bash
arctl agent build diceagent && arctl agent run diceagent/
```

4. Scaffold a new MCP server - look at `echo.py`

```bash
arctl mcp init python my-mcp-server --author pmuir --email pete.muir@solo.io --version 0.1.4
```

5. Explore the MCP server

6. Build and publish the new MCP server - this will publish the mcp server to our registry including: a reference to the source on github, and docker images

```bash
arctl mcp publish my-mcp-server --docker-url docker.io/pmuir --github https://github.com/pmuir/my-mcp-server --push
```

```bash
cd my-mcp-server
git remote add -f origin git@github.com:pmuir/my-mcp-server.git
git add *
git commit -m "initial commit"
git push -f origin HEAD
cd ..

```

7. Add the new MCP server to the agent blueprint (all the dependencies needed for the agent so the registry can make sure to deploy everything it needs)

```bash
arctl agent add-mcp echo-mcp-server --registry-url ${AGENTREGISTRY_URL} --registry-server-name pmuir/my-mcp-server --registry-server-version 0.1.4 --env MCP_TRANSPORT_MODE=http --env HOST=0.0.0.0 --project-dir diceagent
```

8. Run the agent locally. Example prompts are: "What can you do" and "Roll a 6 sided die and echo back the result". Ctrl-c to exit

```bash
arctl agent build diceagent && arctl agent run diceagent/
```

10. Build & push a doceker image for the agent

```bash
arctl agent build diceagent --image docker.io/pmuir/diceagent:1 --push
```

11. Push the agent source to git

```bash
cd diceagent
git remote add -f origin git@github.com:pmuir/diceagent.git
git add *
git commit -m "initial commit"
git push -f origin HEAD
cd ..

```

12. Publish the agent to the registry

```bash
arctl agent publish diceagent --github https://github.com/pmuir/diceagent
```

12. To deploy to k8s
```bash
arctl agent deploy diceagent --runtime kubernetes --namespace default
```


13. In the UI deploy to Vertex. You need these env vars

```bash
OTEL_EXPORTER_OTLP_TRACES_ENDPOINT=http://telemetry.agentregistry.a.solo-agentic-demo.com/v1/traces
```

14.With the CLI deploy to AWS

```bash
arctl agent deploy diceagent  --runtime aws --platform-id productaws --env GEMINI_API_KEY=${GOOGLE_API_KEY} --env OTEL_EXPORTER_OTLP_TRACES_ENDPOINT=${TELEMETRY_ENDPOINT}
```

15. Fix the MCP server (bug)

In AWS, you can click on the MCP server, then the Update hosting. Then in Advanced Configurations at the bottom, you can add that one env variable `MCP_STATELESS_HTTP=true`.

16. To chat with the agent, use the AWS playground. Go to https://us-west-2.console.aws.amazon.com/bedrock-agentcore/agents

Click on the agent, then the DEFAULT endpoint then Test Endpoint.

Paste this prompt into the input area

```json
  {
    "jsonrpc": "2.0",
    "method": "tasks/send",
    "id": "1",
    "params": {
      "id": "<task-id>",
      "message": {
        "role": "user",
        "parts": [
          {
            "type": "text",
            "text": "What can you do?"
          }
        ]
      }
    }
  }
```

