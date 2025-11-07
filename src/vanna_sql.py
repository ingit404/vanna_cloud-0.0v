import vanna
from vanna.base import VannaBase
from qdrant_cloud  import MyQdrantVectorStore
from gemini import GeminiLLM

class MyVanna(MyQdrantVectorStore, GeminiLLM, VannaBase):
    """
    Vanna instance using Qdrant for vectorstore and GeminiLLM (custom wrapper) as the LLM.
    """
    def __init__(self, config=None):
        # ✅ Let Python's MRO handle initialization
        super().__init__(config=config)

if __name__ == "__main__":
    print("MyVanna module loaded successfully ✅")
