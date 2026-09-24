package net.sunjiao.renamer

import android.net.Uri
import android.provider.DocumentsContract

/**
 * Expand only a bare tree URI returned by ACTION_OPEN_DOCUMENT_TREE.
 *
 * Tree-scoped document URIs already identify their target. In particular, a
 * rename can return /tree/old-id/document/new-id: replacing its document ID
 * with the tree ID would query or rename the old document instead.
 */
internal fun resolveDocumentUri(uri: Uri): Uri {
    if (DocumentsContract.isTreeUri(uri) && uri.pathSegments.size == 2) {
        return DocumentsContract.buildDocumentUriUsingTree(
            uri,
            DocumentsContract.getTreeDocumentId(uri)
        )
    }
    return uri
}
